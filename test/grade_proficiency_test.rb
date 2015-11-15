require 'minitest'
require 'grade_proficiency'

class GradeProficiencyTest < Minitest::Test
  def test_class_exists
    assert GradeProficiency
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', t.name
    assert_equal data, t.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', t.name
    assert_equal expected, t.data
  end

  def test_can_be_initialized_with_data_that_contains_nas
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 'N/A', writing: 0.1234 },
             2009 => { math: 'N/A', reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', t.name
    assert_equal data, t.data
  end

  def test_returns_truncated_proficiency_for_all_years
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => { math: 0.857, reading: 0.847, writing: 0.788 },
                 2008 => { math: 0.473, reading: 0.473, writing: 0.123 },
                 2009 => { math: 0.291, reading: 0.900, writing: 0.543 } }

    assert_equal expected, t.proficiency_by_year
  end

  def test_returns_truncated_proficiency_for_all_years_with_nas
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 'N/A', writing: 0.1234 },
             2009 => { math: 'N/A', reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => { math: 0.857, reading: 0.847, writing: 0.788 },
                 2008 => { math: 0.473, reading: 'N/A', writing: 0.123 },
                 2009 => { math: 'N/A', reading: 0.900, writing: 0.543 } }

    assert_equal expected, t.proficiency_by_year
  end

  def test_returns_truncated_proficiency_for_one_year
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: 0.473, reading: 0.473, writing: 0.123 }

    assert_equal expected, t.proficiency_in_year(2008)
  end

  def test_returns_truncated_proficiency_for_one_year_with_nas
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: 0.857, reading: 'N/A', writing: 0.788 }

    assert_equal expected, t.proficiency_in_year(2007)
  end

  def test_returns_empty_hash_if_year_does_not_exist
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = {}

    assert_equal expected, t.proficiency_in_year(2015)
  end

  def test_returns_percentage_for_a_specific_subject_and_year
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.291, t.proficiency_in_year_and_subject(2009, :math)
  end

  def test_returns_na_for_a_specific_subject_and_year
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'N/A', t.proficiency_in_year_and_subject(2007, :reading)
  end

  def test_returns_unknown_data_error_if_subject_doesnt_exist
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    exception = assert_raises(UnknownDataError) { t.proficiency_in_year_and_subject(2009, :science) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_returns_unknown_data_error_if_year_doesnt_exist
    data = { 2007 => { math: 0.857, reading: 'N/A', writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    exception = assert_raises(UnknownDataError) { t.proficiency_in_year_and_subject(2015, :math) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_proficiency_by_subject_returns_proficiency_sorted_by_subject
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: { 2007 => 0.857, 2008 => 0.47336, 2009 => 0.2911 },
                 reading: { 2007 => 0.8473, 2008 => 0.473, 2009 => 0.900 },
                 writing: { 2007 => 0.7889, 2008 => 0.1234, 2009 => 0.54367 } }

    assert_equal expected, t.proficiency_by_subject
  end

  def test_proficiency_for_subject_returns_data_for_all_years_for_subject
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => 0.857, 2008 => 0.47336, 2009 => 0.2911 }

    assert_equal expected, t.proficiency_for_subject(:math)
  end

  def test_proficiency_for_subject_returns_exception_for_unknown_subject
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) { t.proficiency_for_subject(:science) }
  end

  def test_avg_percentage_growth_calculates_average_percentage_growth_across_years
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    assert_equal 1.5, t.average_percentage_growth([1, 3, 4])
  end

  def test_avg_percentage_growth_calculates_for_floats
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    expected = 1.6099999999999999

    assert_equal expected, t.average_percentage_growth([1.12, 3.32, 4.34])
  end

  def test_avg_percentage_growth_removes_nas_when_performing_calculations
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    values = [0.34, 0.37, 0.41, 'N/A', 0.456]
    expected = 0.03866666666666666

    assert_equal expected, t.average_percentage_growth(values)
  end

  def test_avg_percentage_growth_can_be_calculated_for_a_subject
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal -0.283, t.average_percentage_growth_by_subject(:math)
    assert_equal 0.026, t.average_percentage_growth_by_subject(:reading)
    assert_equal -0.123, t.average_percentage_growth_by_subject(:writing)
    assert_raises(UnknownDataError) { t.average_percentage_growth_by_subject(:science) }
  end

  def test_avg_percentage_growth_can_be_calculated_for_all_subjects
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = { math: -0.283, reading: 0.026, writing: -0.123 }

    assert_equal expected, t.average_percentage_growth_all_subjects
  end
end
