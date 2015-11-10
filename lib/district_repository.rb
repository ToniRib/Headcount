require_relative 'kindergarten_parser'
require_relative 'district'
require_relative 'enrollment_repository'
require 'pry'

class DistrictRepository
  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(options)
    data = KindergartenParser.new.parse(options[:enrollment][:kindergarten])
    @enrollment_repo.load_data(options)
    data.keys.each do |district_name|
      @districts[district_name.upcase] = District.new(name: district_name)
      @districts[district_name.upcase].enrollment = @enrollment_repo.enrollments[district_name.upcase]
    end
  end

  # def make_district(district_name)
  #
  #
  # end

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

  district = dr.find_by_name("ACADEMY 20")
end
