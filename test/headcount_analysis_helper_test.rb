require 'minitest'
require 'headcount_analysis_helper'

class HeadcountAnalystHelperTest < Minitest::Test
  def test_calculate_ratio_returns_ratio_of_two_values
    ha = HeadcountAnalystHelper.new

    assert_equal 0.500, ha.calculate_ratio(1, 2)
  end

  def test_calculate_ratio_returns_na_if_second_value_is_na
    ha = HeadcountAnalystHelper.new

    assert_equal 'N/A', ha.calculate_ratio(1, 'N/A')
  end

  def test_calculate_ratio_returns_na_if_second_value_is_na
    ha = HeadcountAnalystHelper.new

    assert_equal 'N/A', ha.calculate_ratio('N/A', 1)
  end

  def test_calculate_ratio_returns_na_if_both_values_na
    ha = HeadcountAnalystHelper.new

    assert_equal 'N/A', ha.calculate_ratio('N/A', 'N/A')
  end

  def test_number_is_within_correlation_range
    ha = HeadcountAnalystHelper.new

    assert ha.in_correlation_range?(0.8)
  end

  def test_number_is_on_low_edge_of_correlation_range
    ha = HeadcountAnalystHelper.new

    assert ha.in_correlation_range?(0.6)
  end

  def test_number_is_on_high_edge_of_correlation_range
    ha = HeadcountAnalystHelper.new

    assert ha.in_correlation_range?(1.5)
  end

  def test_number_is_below_correlation_range
    ha = HeadcountAnalystHelper.new

    refute ha.in_correlation_range?(0.2)
  end

  def test_number_is_above_correlation_range
    ha = HeadcountAnalystHelper.new

    refute ha.in_correlation_range?(1.6)
  end

  def test_growth_value_over_range
    input = {2001 => 1, 2002 => 2, 2003 => 3, 2004 => 4}
    ha = HeadcountAnalystHelper.new
    expected = 0.75

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_over_constant_range
    x = rand(0..100)
    input = {2001 => x, 2002 => x, 2003 => x, 2004 => x}
    ha = HeadcountAnalystHelper.new
    expected = 0

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_one_item
    input = {2001 => 3}
    ha = HeadcountAnalystHelper.new
    expected = ha.not_enough_data

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_no_items
    input = {}
    ha = HeadcountAnalystHelper.new
    expected = ha.not_enough_data

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_pulls_largest_growth_value
    input = [[3,"COLORADO"],[4,"HIGLAND"],[2,"HEY TONI!!!"]]
    ha = HeadcountAnalystHelper.new
    expected = ["HIGLAND",4]

    assert_equal expected, ha.return_largest_growth_value(input)
  end

  def test_pulls_largest_growth_values
    input = [[3,"COLORADO"],[4,"HIGLAND"],[2,"HEY TONI!!!"],[6,"AHHHH"]]
    ha = HeadcountAnalystHelper.new
    expected = [["AHHHH",6],["HIGLAND",4]]

    assert_equal expected, ha.return_largest_growth_value(input,2)
  end

  def test_pulls_largest_growth_value_with_no_datas
    ha = HeadcountAnalystHelper.new
    input = [[ha.not_enough_data,"COLORADO"],[ha.not_enough_data,"HIGLAND"],[2,"HEY TONI!!!"]]
    expected = ["HEY TONI!!!",2]

    assert_equal expected, ha.return_largest_growth_value(input)
  end
end
