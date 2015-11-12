require_relative 'year_percent_parser'
require_relative 'statewide_test'
require_relative 'pre_processor'
require_relative 'post_processor'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(options)
    post = PostProcessor.new
    data = post.get_statewide_testing_data(options)

    data.each_pair do |district_name, district_data|
      stest_options = { name: district_name.upcase }.merge(district_data)
      @statewide_tests[district_name.upcase] = StatewideTest.new(stest_options)
    end
  end

  def find_by_name(district_name)
    @statewide_tests[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    @statewide_tests.keys.include?(district_name.upcase)
  end
end

if __FILE__ == $PROGRAM_NAME
  sw = StatewideTestRepository.new
  sw.load_data( :statewide_testing => {
                :third_grade => "./test/fixtures/third_grade_tester.csv",
                :eighth_grade => "./test/fixtures/eighth_grade_tester.csv"
                }
  )
  p sw.find_by_name('ACADEMY 20')
end
