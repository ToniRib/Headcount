require_relative 'year_percent_parser'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(options)
    data = get_data(options)
    transpose_data(data)
    # district_names = get_names(data)
    binding.pry

    data.each_pair do |district_name, district_data|
      enroll_options = { :name => district_name.upcase,
                         district_data}
      @enrollments[district_name.upcase] = Enrollment.new(enroll_options)
    end
  end

  def get_data(options)
    { :kindergarten => get_year_percent_data(options[:enrollment][:kindergarten]),
      :highschool => get_year_percent_data(options[:enrollment][:high_school_graduation]) }
  end
  #
  # def get_names(hash)
  #
  # end

  def get_year_percent_data(file)
    return nil if file.nil?
    YearPercentParser.new.parse(file)
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
