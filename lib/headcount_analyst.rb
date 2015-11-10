class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def find_enrollment_by_name(district_name)
    @district_repository.find_by_name(district_name).enrollment
  end

  def kindergarten_participation_rate_variation(district_name, options)
    first_district_enrollment = find_enrollment_by_name(district_name)
    second_district_enrollment = find_enrollment_by_name(options[:against])

    average1 = first_district_enrollment.average(:kindergarten_participation)
    average2 = second_district_enrollment.average(:kindergarten_participation)
    first_district_enrollment.truncate_value(average1 / average2)
  end

  def kindergarten_participation_rate_variation_trend(district_name,options)
    variation = {}

    first_district_enrollment = find_enrollment_by_name(district_name)
    second_district_enrollment = find_enrollment_by_name(options[:against])

    first_district_enrollment.kindergarten_participation.each do |year,data|
      variation[year] = first_district_enrollment.truncate_value(calculate_variation(data,second_district_enrollment.kindergarten_participation[year]))
    end

    variation

  end

  def calculate_variation(data1, data2)
    return 'N/A' if data1 == 'N/A' || data2 == 'N/A'
    data1 / data2
  end

end


# ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766


# ha.ticipation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
 # => {2009 => 0.766, 2010 => 0.566, 2011 => 0.46 }
