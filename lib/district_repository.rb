require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'data_formattable'
require_relative 'statewide_testing_repository'
require 'pry'

class DistrictRepository
  include DataFormattable

  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_test_repo = StatewideTestRepository.new
  end

  def load_data(options)
    options = hash_leaves_go_empty_hashes(options)
    # options = {
    #   :enrollment => {
    #     :kindergarten => "./test/fixtures/kindergarten_tester.csv",
    #     :high_school_graduation => "./test/fixtures/highschool_grad_tester.csv"
    #   },
    #   :statewide_testing => {
    #     :third_grade => "./test/fixtures/third_grade_tester.csv",
    #     :math => "./test/fixtures/math_average_proficiency_tester.csv"
    #   }
    # }
    # data = KindergartenParser.new.parse(options[:enrollment][:kindergarten])
    # later iterations must change this.

    @enrollment_repo.load_data(:enrollment => options[:enrollment])
    @statewide_test_repo.load_data(:statewide_testing => options[:statewide_testing])

    enroll_names = @enrollment_repo.enrollments.keys
    statewidetest_names = @statewide_test_repo.statewide_tests.keys

    names = enroll_names | statewidetest_names

    @enrollment_repo.enrollments.keys.each do |district_name|
      @districts[district_name.upcase] = District.new(name: district_name)
      enrollment = @enrollment_repo.enrollments[district_name.upcase]
      @districts[district_name.upcase].enrollment = enrollment

    end
  end

  def find_by_name(district_name)
    @districts[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    @districts.keys.include?(district_name.upcase)
  end

  def find_all_matching(str)
    @districts.select { |name, _| name.start_with?(str.upcase) }.values
  end
end

if __FILE__ == $PROGRAM_NAME
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => './test/fixtures/kindergarten_tester.csv',
      :high_school_graduation => './test/fixtures/highschool_grad_tester.csv'
    }
  })

  p dr.find_by_name('ACADEMY 20')
end
