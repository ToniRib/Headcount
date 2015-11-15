require 'statewide_testing_repository'
require 'minitest'

class StatewideTestRespositoryTest < Minitest::Test
  def load_short_grade_proficiency_data
    sw = StatewideTestRepository.new
    sw.load_data( :statewide_testing => {
                  :third_grade => "./test/fixtures/third_grade_tester.csv",
                  :eighth_grade => "./test/fixtures/eighth_grade_tester.csv"
                  })
    sw
  end

  def test_calculates_average_percent_growth_for_all_districts
    sw = load_short_grade_proficiency_data
    # binding.pry
  
  end
end
