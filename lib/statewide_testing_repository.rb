require_relative 'statewide_test'
require_relative 'post_processor'

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
