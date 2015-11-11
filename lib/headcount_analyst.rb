class HeadcountAnalyst
  attr_reader :district_repository

  include DataFormattable

  def initialize(dr)
    @district_repository = dr
  end

  def find_enrollment_by_name(district_name)
    @district_repository.find_by_name(district_name).enrollment
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    k = kindergarten_participation_rate_variation(district_name,
                                                  against: 'COLORADO')
    g = highschool_graduation_rate_variation(district_name,
                                             against: 'COLORADO')
    calculate_ratio(k, g)
  end

  def kindergarten_participation_rate_variation(district_name, vs)
    general_rate_variation(:kindergarten_participation, district_name, vs)
  end

  def highschool_graduation_rate_variation(district_name, vs)
    general_rate_variation(:high_school_graduation, district_name, vs)
  end

  def general_rate_variation(type, district_name, vs)
    district_enrollment1 = find_enrollment_by_name(district_name)
    district_enrollment2 = find_enrollment_by_name(vs[:against])

    average1 = district_enrollment1.average(type)
    average2 = district_enrollment2.average(type)
    calculate_ratio(average1, average2)
  end

  def kindergarten_participation_rate_variation_trend(district_name, vs)
    variation = {}

    kp_dist1 = find_enrollment_by_name(district_name).kindergarten_participation
    kp_dist2 = find_enrollment_by_name(vs[:against]).kindergarten_participation

    kp_dist1.each do |year, data|
      variation[year] = calculate_ratio(data, kp_dist2[year])
    end

    variation
  end

  def calculate_ratio(data1, data2)
    return 'N/A' if na?(data1) || na?(data2)

    truncate_value(data1 / data2)
  end

  def in_correlation_range?(value)
    (0.6..1.5).cover?(value)
  end

  def kgp_correlates_with_hgr_district(district_name)
    x = kindergarten_participation_against_high_school_graduation(district_name)
    in_correlation_range?(x)
  end

  def kgp_correlates_with_hgr_range(district_names)
    correlated = 0

    correlated += district_names.reduce(0) do |acc, district_name|
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
end
