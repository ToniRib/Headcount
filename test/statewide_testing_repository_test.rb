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
end
