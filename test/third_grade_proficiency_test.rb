require 'minitest'
require 'third_grade_proficiency'

class ThirdGradeProficiencyTest < Minitest::Test
  def test_class_exists
    assert ThirdGradeProficiency
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', t.name
    assert_equal data, t.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', t.name
    assert_equal expected, t.data
  end
end
