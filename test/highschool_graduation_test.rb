require 'minitest'
require 'highschool_graduation'

class HighschoolGraduationTest < Minitest::Test
  def test_class_exists
    assert HighschoolGraduation
  end

  def test_can_be_initialized_with_data
    data = { 2007 => 0.513, 2008 => 0.475 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', h.name
    assert_equal data, h.data
  end

  def test_can_be_initialized_with_no_data
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', h.name
    assert_equal expected, h.data
  end

  def test_returns_truncated_graduation_percentages_for_all_years
    data = { 2007 => 0.51378, 2008 => 0.47561, 2009 => 1 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => 0.513, 2008 => 0.475, 2009 => 1.000 }

    assert_equal expected, h.graduation_rate_by_year
  end

  def test_returns_truncated_graduation_with_na
    data = { 2007 => 0.51378, 2008 => 0.47561, 2009 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    expected = { 2007 => 0.513, 2008 => 0.475, 2009 => 'N/A' }

    assert_equal expected, h.graduation_rate_by_year
  end

  def test_can_return_graduation_for_one_year
    data = { 2007 => 0.5137, 2008 => 0.475 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.513, h.graduation_rate_in_year(2007)
  end

  def test_returns_nil_if_data_doesnt_exist_for_given_year
    data = { 2007 => 0.513, 2008 => 0.475 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_nil h.graduation_rate_in_year(2015)
  end

  def test_returns_na_if_data_for_year_is_na
    data = { 2007 => 0.513, 2008 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 'N/A', h.graduation_rate_in_year(2008)
  end

  def test_returns_nil_if_something_other_than_integer_passed_in
    data = { 2007 => 0.513, 2008 => 0.475 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_nil h.graduation_rate_in_year('2015')
  end

  def test_counts_non_nas_in_data
    data = { 2007 => 0.513, 2008 => 0.475, 2009 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 2, h.count_non_na
  end

  def test_counts_non_nas_in_data_no_nas
    data = { 2007 => 0.513, 2008 => 0.475, 2009 => 0.345 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 3, h.count_non_na
  end

  def test_counts_non_nas_in_data_all_nas
    data = { 2007 => 'N/A', 2008 => 'N/A', 2009 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 0, h.count_non_na
  end

  def test_totals_data_no_nas
    data = { 2007 => 0.513, 2008 => 0.475, 2009 => 0.345 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 1.333, h.total
  end

  def test_totals_data_with_nas
    data = { 2007 => 0.513, 2008 => 'N/A', 2009 => 0.345 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 1.333-0.475, h.total
  end

  def test_totals_data_with_all_nas
    data = { 2007 => 'N/A', 2008 => 'N/A', 2009 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 0, h.total
  end

  def test_averages_no_nas
    data = { 2007 => 0.513, 2008 => 0.475, 2009 => 0.345 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 1.333/3, h.average
  end

  def test_averages_with_nas
    data = { 2007 => 0.513, 2008 => 'N/A', 2009 => 0.345 }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal (1.333-0.475)/2, h.average
  end

  def test_averages_with_all_nas
    data = { 2007 => 'N/A', 2008 => 'N/A', 2009 => 'N/A' }
    h = HighschoolGraduation.new(name: 'ACADEMY 20', data: data )

    assert_equal 'N/A', h.average
  end
end
