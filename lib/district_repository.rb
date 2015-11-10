require_relative 'kindergarten_parser'
require_relative 'district'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(parser_to_file)
    data = KindergartenParser.new.parse(parser_to_file[:kindergarten])
    data.keys.each do |district_name|
      @districts[district_name.upcase] = District.new(name: district_name)
      # @districts[district_name].load_kinder_data(data[district_name])
      # @districts[district_name].enrollments.kindergarten = data[district_name]
    end
  end

  def find_by_name(district_name)
    if district_exists?(district_name)
      @districts[district_name.upcase]
    else
      "District #{district_name} does not exist in database"
    end
  end

  def district_exists?(district_name)
    @districts.keys.include?(district_name.upcase)
  end

end


if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
  district = dr.find_by_name("ACADEMY 20")
end
