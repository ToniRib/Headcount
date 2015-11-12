require_relative 'year_percent_parser'
require_relative 'enrollment'
require_relative 'pre_processor'
require_relative 'post_processor'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(options)
    post = PostProcessor.new
    data = post.get_enrollment_data(options)

    data.each_pair do |district_name, district_data|
      enrollment_options = { name: district_name.upcase }.merge(district_data)
      @enrollments[district_name.upcase] = Enrollment.new(enrollment_options)
    end
  end

  def find_by_name(district_name)
    @enrollments[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    @enrollments.keys.include?(district_name.upcase)
  end
end

if __FILE__ == $PROGRAM_NAME
  er = EnrollmentRepository.new
  er.load_data(:enrollment =>
                { :kindergarten => './test/fixtures/kindergarten_tester.csv',
                  :high_school_graduation => './test/fixtures/highschool_grad_tester.csv' })
  # er.load_data(
  #   {
  #     :enrollment => {
  #       :kindergarten => './data/Kindergartners in full-day program.csv',
  #       :high_school_graduation => './data/High school graduation rates.csv'
  #     }
  #   }
  # )
  p er.find_by_name('ACADEMY 20')
end
