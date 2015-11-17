require 'median_household_income'
require 'minitest'

class MedianHouseholdIncomeTest < Minitest::Test
  def test_class_exists
    assert MedianHouseholdIncome
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { [2005, 2009] => 85604, [2006, 2010] => 89736 }

    mhi = MedianHouseholdIncome.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', mhi.name
    assert_equal data, mhi.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    mhi = MedianHouseholdIncome.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', mhi.name
    assert_equal expected, mhi.data
  end

  def test_can_calculate_median_household_income_in_a_year
    data = { [2005, 2009] => 85604, [2006, 2010] => 89736, [2007, 2011] => 90362 }

    mhi = MedianHouseholdIncome.new(name: 'ACADEMY 20', data: data )

    assert_equal 85604, mhi.estimated_median_household_income_in_year(2005)
    assert_equal 87670, mhi.estimated_median_household_income_in_year(2006)
    assert_equal 88567, mhi.estimated_median_household_income_in_year(2007)
  end
end
