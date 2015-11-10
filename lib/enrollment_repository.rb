

# The EnrollmentRepository is responsible for holding and searching our Enrollment instances. It offers the following methods:
#
# find_by_name - returns either nil or an instance of Enrollment having done a case insensitive search
# For iteration 0, the instance of this object represents one line of data from the file Kindergartners in full-day program.csv. It's initialized and used like this:
#
# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# # => <Enrollment>


require_relative 'kindergarten_parser'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(options)
    data = KindergartenParser.new.parse(options[:enrollment][:kindergarten])
    data.keys.each do |district_name|
      enroll_options = { :name => district_name.upcase, :kindergarten_participation => data[district_name] }
      @enrollments[district_name.upcase] = Enrollment.new(enroll_options)
    end
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
