class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_name, options)
    first_district_enrollment = @district_repository.find_by_name(district_name).enrollment
    second_district_enrollment = @district_repository.find_by_name(options[:against]).enrollment

    average1 = first_district_enrollment.average(:kindergarten_participation)
    average2 = second_district_enrollment.average(:kindergarten_participation)
    first_district_enrollment.truncate_value(average1 / average2)
  end

end


# ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766
