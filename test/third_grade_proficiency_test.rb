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

  def test_can_be_initialized_with_data_that_contains_nas
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 'N/A', writing: 0.1234 },
             2009 => { math: 'N/A', reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', t.name
    assert_equal data, t.data
  end

  def test_returns_truncated_proficiency_for_all_years
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => { math: 0.857, reading: 0.847, writing: 0.788 },
                 2008 => { math: 0.473, reading: 0.473, writing: 0.123 },
                 2009 => { math: 0.291, reading: 0.900, writing: 0.543 } }

    assert_equal expected, t.proficiency_by_year
  end

  def test_returns_truncated_proficiency_for_all_years_with_nas
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 'N/A', writing: 0.1234 },
             2009 => { math: 'N/A', reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => { math: 0.857, reading: 0.847, writing: 0.788 },
                 2008 => { math: 0.473, reading: 'N/A', writing: 0.123 },
                 2009 => { math: 'N/A', reading: 0.900, writing: 0.543 } }

    assert_equal expected, t.proficiency_by_year
  end

  def test_returns_truncated_proficiency_for_one_year
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: 0.473, reading: 0.473, writing: 0.123 }

    assert_equal expected, t.proficiency_in_year(2008)
  end

  def test_returns_truncated_proficiency_for_one_year_with_nas
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = ThirdGradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: 0.857, reading: 'N/A', writing: 0.788 }

    assert_equal expected, t.proficiency_in_year(2007)
  end
end
