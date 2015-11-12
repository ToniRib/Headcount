require 'minitest'
require 'statewide_testing'

class StatewideTestingTest < Minitest::Test
  def test_class_exists
    assert StatewideTesting
  end
end
