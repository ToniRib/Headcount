require_relative 'district_repository'
require_relative 'data_formattable'

class HeadcountAnalyst
  attr_reader :district_repository

  include DataFormattable
  include DataCalculatable

  def initialize(dr)
    @district_repository = dr
  end

  def district_names
    names = @district_repository.district_names_across_repositories
    names.delete('COLORADO')
    names
  end

  def find_enrollment_by_name(name)
    @district_repository.find_by_name(name).enrollment
  end

  def find_swtest_by_name(name)
    @district_repository.find_by_name(name).statewide_test
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    k = kindergarten_participation_rate_variation(district_name,
                                                  against: 'COLORADO')
    g = highschool_graduation_rate_variation(district_name,
                                             against: 'COLORADO')

    calculate_ratio(k, g)
  end

  def kindergarten_participation_rate_variation(district_name, vs)
    average1 = find_enrollment_by_name(district_name).kp.average
    average2 = find_enrollment_by_name(vs[:against]).kp.average

    calculate_ratio(average1, average2)
  end

  def highschool_graduation_rate_variation(district_name, vs)
    average1 = find_enrollment_by_name(district_name).hs.average
    average2 = find_enrollment_by_name(vs[:against]).hs.average

    calculate_ratio(average1, average2)
  end

  def kindergarten_participation_rate_variation_trend(district_name, vs)
    variation = {}

    kp_dist1 = find_enrollment_by_name(district_name).kp.data
    kp_dist2 = find_enrollment_by_name(vs[:against]).kp.data

    kp_dist1.each do |year, data|
      variation[year] = calculate_ratio(data, kp_dist2[year])
    end

    variation
  end

  def in_correlation_range?(value)
    (0.6..1.5).cover?(value)
  end

  def kgp_correlates_with_hgr_district(district_name)
    x = kindergarten_participation_against_high_school_graduation(district_name)
    in_correlation_range?(x)
  end

  def kgp_correlates_with_hgr_range(district_names)
    correlated = district_names.reduce(0) do |acc, district_name|
      acc + bool_to_binary[kgp_correlates_with_hgr_district(district_name)]
    end

    0.7 < correlated.to_f / district_names.length
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'STATEWIDE'
      district_names = @district_repository.districts.keys - ['COLORADO']
      kgp_correlates_with_hgr_range(district_names)
    elsif options[:across]
      kgp_correlates_with_hgr_range(options[:across])
    else
      kgp_correlates_with_hgr_district(options[:for])
    end
  end

  def top_statewide_test_year_over_year_growth(options)
    raise_insufficient_info_error unless options.key?(:grade)

    if options.key?(:subject)
      g = growth_by_district(options)
    else
      g = combined_growth_by_district(options)
    end

    format_growth(g, options)
  end

  def format_growth(g, options)
    g = sort_districts_by_growth(g)[0..(options.fetch(:top, 1) - 1)]
    g.flatten! if g.count == 1
    g
  end

  def sort_districts_by_growth(districts)
    districts.select { |d| !d[1].nil? }.sort_by { |_, val| val }.reverse
  end

  def combined_growth_by_district(options)
    options = check_and_set_weights(options)

    district_names.map do |name|
      [name, get_weighted_growth(options, name)]
    end
  end

  def get_weighted_growth(options, name)
    st = find_swtest_by_name(name)
    st.avg_growth_by_grade_all_subjects(options[:grade], options[:weighting])
  rescue
    nil
  end

  def check_and_set_weights(options)
    options[:weighting] = standard_weights unless options.key?(:weighting)

    fail ArgumentError if options[:weighting].values.reduce(:+) != 1.0

    options
  end

  def standard_weights
    { math: 1.0 / 3, reading: 1.0 / 3, writing: 1.0 / 3 }
  end

  def growth_by_district(options)
    district_names.map do |name|
      [name, get_subject_growth(options, name)]
    end
  end

  def get_subject_growth(options, name)
    st = find_swtest_by_name(name)
    st.avg_growth_by_grade_for_subject(options[:grade], options[:subject])
  rescue
    nil
  end

  def raise_insufficient_info_error
    fail InsufficientInformationError,
         'A grade must be provided to answer this question'
  end
end
