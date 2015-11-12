require_relative 'year_percent_parser'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments, :file_repo

  def initialize(file_repo = nil)
    @file_repo = file_repo
    @enrollments = {}
  end

  def load_data(options)
    #{:enrollment=>{:kindergarten=>"./test/fixtures/kindergarten_tester.csv"}}
    data = get_data(options)
    data = transpose_data(data)
    data.each_pair do |district_name, district_data|
      enrollment_options = { name: district_name.upcase }.merge(district_data)
      @enrollments[district_name.upcase] = Enrollment.new(enrollment_options)
    end
  end

  def get_data(options)
    #{:enrollment=>{:kindergarten=>"./test/fixtures/kindergarten_tester.csv"}}
    { :kindergarten_participation => get_year_percent_data(options[:enrollment][:kindergarten]),
      :high_school_graduation => get_year_percent_data(options[:enrollment][:high_school_graduation]) }
  end

  def transpose_data(data)
    data_transpose = Hash.new{ |h, k| h[k] = {} }

    data.each_pair do |type, district|
      district.to_h.each_pair{ |name, d| data_transpose[name][type] = d }
    end

    data_transpose
  end

  def get_year_percent_data(file)
    return nil if file.nil?
    file_repo.load_file(file)
    YearPercentParserFileRepo.new.parse(file_repo,file)
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
      :kindergarten => "./test/fixtures/kindergarten_tester.csv",
      :high_school_graduation => "./test/fixtures/highschool_grad_tester.csv"
    }
  })
  # er.load_data({
  #   :enrollment => {
  #     :kindergarten => "./data/Kindergartners in full-day program.csv",
  #     :high_school_graduation => "./data/High school graduation rates.csv"
  #   }
  # })
  enrollment = er.find_by_name("ACADEMY 20")
end
