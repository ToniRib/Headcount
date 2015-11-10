class HeadcountAnalyst

  attr_reader :district_repository

  def initialize(dr)
    @district_repository = dr
  end

  def kindergarten_participation_rate_variation(district_name, options)
    average1 = @district_repository.find_by_name(district_name).enrollment.average(:kindergarten_participation)
    average2 = @district_repository.find_by_name(options[:against]).enrollment.average(:kindergarten_participation)
    average1 / average2
  end

  # def average(district_name, sub_repo, data) #one data per file
  #
  #   district = district_repository.find_by_name(district_name)
  #   case sub_repo
  #   when :enrollment
  #
  #   end
  #
  #
  # end
end


# ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766
