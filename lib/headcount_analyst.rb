require_relative 'district_repository'
require_relative 'data_formattable'
require_relative 'data_calculatable'

class HeadcountAnalyst
  attr_reader :district_repository

  include DataFormattable
  include DataCalculatable

  def initialize(dr)
    @district_repository = dr
  end

  def find_enrollment_by_name(district_name)
    @district_repository.find_by_name(district_name).enrollment
  end

  def find_statewide_testing_by_name(district_name)
    @district_repository.find_by_name(district_name).statewide_test
  end

  def district_names
    @district_repository.districts.keys
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

  def calculate_ratio(data1, data2)
    return 'N/A' if na?(data1) || na?(data2)

    truncate_value(data1.to_f / data2)
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
    if options[:for] == 'COLORADO'
      district_names = @district_repository.districts.keys - ['COLORADO']
      kgp_correlates_with_hgr_range(district_names)
    elsif options[:across]
      kgp_correlates_with_hgr_range(options[:across])
    else
      kgp_correlates_with_hgr_district(options[:for])
    end
  end

  def top_statewide_test_year_over_year_growth(options)   #(grade: 3, subject: math)
    growth_values = district_names.map do |district|
      test_data = find_statewide_testing_by_name(district)
      test_hash = transpose_data(test_data.proficient_by_grade(options[:grade]))
      subject_hash = test_hash[options[:subject]]
      total = total2(subject_hash)
      denom = count_non_na2(subject_hash)
      [truncate_value(average2(total,denom)),district]
    end
    top_growth = growth_values.reject{|na| na = "N/A"}.sort
    s = top_growth[-1].to_a.reverse
    if s.length == 0
      "N/A, no data"
    end

  end
end
