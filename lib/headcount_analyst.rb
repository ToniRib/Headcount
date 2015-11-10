class HeadcountAnalyst
  attr_reader :district_repository

  include DataFormattable

  def initialize(dr)
    @district_repository = dr
  end

  def find_enrollment_by_name(district_name)
    @district_repository.find_by_name(district_name).enrollment
  end

  def kindergarten_participation_rate_variation(district_name, vs)
    district_enrollment1 = find_enrollment_by_name(district_name)
    district_enrollment2 = find_enrollment_by_name(vs[:against])

    average1 = district_enrollment1.average(:kindergarten_participation)
    average2 = district_enrollment2.average(:kindergarten_participation)
    calculate_ratio(average1, average2)
  end

  def kindergarten_participation_rate_variation_trend(district_name,vs)
    variation = {}

    kp_dist1 = find_enrollment_by_name(district_name).kindergarten_participation
    kp_dist2 = find_enrollment_by_name(vs[:against]).kindergarten_participation

    kp_dist1.each do |year,data|
      variation[year] = calculate_ratio(data,kp_dist2[year])
    end

    variation
  end

  def calculate_ratio(data1, data2)
    return 'N/A' if is_na?(data1) || is_na?(data2)
    truncate_value(data1 / data2)
  end
end
