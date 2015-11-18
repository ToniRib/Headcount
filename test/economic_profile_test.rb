require 'economic_profile'
require 'minitest'

class EconomicProfileTest < Minitest::Test
  def test_class_exists
      assert EconomicProfile
  end

  def set_up_economic_profile
    data = {:name => 'ACADEMY 20',
            :median_household_income => { [2005, 2009] => 50000, [2008, 2014] => 60000},
            :children_in_poverty => { 2012 => 0.1845},
            :free_or_reduced_price_lunch => { 2014 => { :percentage => 0.023, :total => 100 } },
            :title_i => { 2015 => 0.543 }
    }

    ep = EconomicProfile.new(data)
  end

  def test_calculates_esimated_median_income_for_year
    ep = set_up_economic_profile

    assert_equal 50000, ep.estimated_median_household_income_in_year(2005)
    assert_equal 55000, ep.estimated_median_household_income_in_year(2008)
  end

  def test_calculates_median_household_income_average
    ep = set_up_economic_profile

    assert_equal 55000, ep.median_household_income_average
  end

  def test_returns_percentage_of_children_in_poverty_in_year
    ep = set_up_economic_profile

    assert_equal 0.184, ep.children_in_poverty_in_year(2012)
  end

  def test_calculates_percentage_of_children_with_free_or_reduced_lunch
    ep = set_up_economic_profile

    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end
end
