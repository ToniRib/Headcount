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
    data = transpose_data(data)

    data.each_pair do |district_name, district_data|
      enrollment_options = { name: district_name.upcase }.merge(district_data)
      @enrollments[district_name.upcase] = Enrollment.new(enrollment_options)
    end
  end

  def get_data(opts)
    {
      kindergarten_participation: year_percent_data(kindergarten_file(opts)),
      high_school_graduation: year_percent_data(high_school_grad_file(opts))
    }
  end

  def kindergarten_file(options)
    options[:enrollment][:kindergarten]
  end

  def high_school_grad_file(options)
    options[:enrollment][:high_school_graduation]
  end

  def transpose_data(data)
    data_transpose = Hash.new { |h, k| h[k] = {} }

    data.each_pair do |type, district|
      district.to_h.each_pair { |name, d| data_transpose[name][type] = d }
    end

    data_transpose
  end

  def year_percent_data(file)
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
