require_relative 'kindergarten_parser'
require_relative 'district'
require 'pry'

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = {}
  end

  def load_data(options)
    # binding.pry
    data = KindergartenParser.new.parse(options[:enrollment][:kindergarten])
    data.keys.each do |district_name|
      @districts[district_name.upcase] = District.new(name: district_name)
      # @districts[district_name].load_kinder_data(data[district_name])
      # @districts[district_name].enrollments.kindergarten = data[district_name]
    end
  end

  def find_by_name(district_name)
    @districts[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    @districts.keys.include?(district_name.upcase)
  end

  def find_all_matching(str)
    @districts.select { |name, value| name.start_with?(str.upcase) }.values
  end
end


if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }
  })
  # binding.pry
  district = dr.find_by_name("ACADEMY 20")
end
