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

  def district_names_across_repositories
    enroll_names = @enrollment_repo.enrollments.keys
    statewidetest_names = @statewide_test_repo.statewide_tests.keys
    (enroll_names | statewidetest_names).map{ |n| n.upcase }
  end

  def load_data(options)
    options = hash_leaves_go_empty_hashes(options)

    @enrollment_repo.load_data(enrollment_data(options))
    @statewide_test_repo.load_data(statewide_test_data(options))

    district_names_across_repositories.each do |name|
      create_district_with_data(name)
    end
  end

  def enrollment_data(options)
    { :enrollment => options[:enrollment] }
  end

  def statewide_test_data(options)
    { :statewide_testing => options[:statewide_testing] }
  end

  def create_district_with_data(name)
    district = District.new(name: name)
    district.enrollment = @enrollment_repo.find_by_name(name)
    district.statewide_test = @statewide_test_repo.find_by_name(name)
    @districts[name] = district
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
