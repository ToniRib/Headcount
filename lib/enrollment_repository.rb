require_relative 'kindergarten_parser'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(options)
    data = get_kindergarten_data(options)
    data.keys.each do |district_name|
      enroll_options = { :name => district_name.upcase,
                         :kindergarten_participation => data[district_name] }
      @enrollments[district_name.upcase] = Enrollment.new(enroll_options)
    end
  end

  def get_kindergarten_data(options)
    KindergartenParser.new.parse(options[:enrollment][:kindergarten])
  end

  def find_by_name(district_name)
    @enrollments[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    @enrollments.keys.include?(district_name.upcase)
  end
end


if __FILE__ == $0
  er = EnrollmentRepository.new
  er.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }
  })
  enrollment = er.find_by_name("ACADEMY 20")
end
