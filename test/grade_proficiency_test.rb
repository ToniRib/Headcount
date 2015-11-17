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

    data = { 2007 => 1, 2008 => 3, 2009 => 4 }

    assert_equal 1.5, t.average_percentage_growth(data)
  end

  def test_avg_percentage_growth_calculates_for_floats
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2007 => 1.12, 2008 => 3.32, 2009 => 4.34 }
    expected = 1.6099999999999999

    assert_equal expected, t.average_percentage_growth(data)
  end

  def test_avg_percentage_growth_returns_exception_for_empty_hash
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    assert_raises(InsufficientInformationError) { t.average_percentage_growth({}) }
  end

  def test_avg_percentage_growth_returns_exception_for_single_element_hash
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2007 => 0.345 }

    assert_raises(InsufficientInformationError) { t.average_percentage_growth(data) }
  end

  def test_avg_percentage_growth_returns_exception_for_hash_with_too_many_nas
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2007 => 'N/A', 2008 => 3.32, 2009 => 'N/A' }

    assert_raises(InsufficientInformationError) { t.average_percentage_growth(data) }
  end

  def test_avg_percentage_growth_does_not_return_exception_for_array_with_2_elements
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2007 => 1, 2008 => 3 }

    assert_equal 2, t.average_percentage_growth(data)
  end

  def test_avg_percentage_growth_removes_nas_when_performing_calculations
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2007 => 0.34, 2008 => 0.37, 2009 => 0.41, 2010 => 'N/A', 2011 => 0.456 }
    expected = 0.028999999999999998

    assert_equal expected, t.average_percentage_growth(data)
  end

  def test_calculates_average_based_on_distance_between_first_and_last_year
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2005 => 1, 2008 => 2, 2009 => 3, 2010 => 'N/A', 2011 => 4 }
    expected = 0.5

    assert_equal expected, t.average_percentage_growth(data)
  end

  def test_calculates_correct_average_based_on_only_two_data_points
    t = GradeProficiency.new(name: 'ACADEMY 20', data: nil )

    data = { 2005 => 'N/A', 2008 => 'N/A', 2009 => 2, 2010 => 4, 2011 => 'N/A', 2012 => 'N/A' }
    expected = 2.0

    assert_equal expected, t.average_percentage_growth(data)
  end

  def test_avg_percentage_growth_can_be_calculated_for_a_subject
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal -0.283, t.avg_percentage_growth_by_subject(:math)
    assert_equal 0.026, t.avg_percentage_growth_by_subject(:reading)
    assert_equal -0.123, t.avg_percentage_growth_by_subject(:writing)
    assert_raises(UnknownDataError) { t.avg_percentage_growth_by_subject(:science) }
  end

  def test_avg_percentage_growth_can_be_calculated_across_all_subjects_standard_weights
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = -0.127
    weights = {:math => 0.333, :reading => 0.333, :writing => 0.333}

    assert_equal expected, t.combined_average_growth(weights)
  end

  def test_avg_percentage_growth_can_be_calculated_across_all_subjects_with_weighting
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = -0.129
    weights = {:math => 0.5, :reading => 0.5, :writing => 0.0}

    assert_equal expected, t.combined_average_growth(weights)
  end

  def test_avg_percentage_growth_can_be_calculated_across_all_subjects_all_weights_zero
    data = { 2007 => { math: 0.857, reading: 0.8473, writing: 0.7889 },
             2008 => { math: 0.47336, reading: 0.473, writing: 0.1234 },
             2009 => { math: 0.2911, reading: 0.900, writing: 0.54367 } }

    t = GradeProficiency.new(name: 'ACADEMY 20', data: data )

    expected = 0
    weights = {:math => 0, :reading => 0, :writing => 0}

    assert_equal expected, t.combined_average_growth(weights)
  end
end
