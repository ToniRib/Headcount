require 'free_lunch'
require 'minitest'

class FreeLunchTest < Minitest::Test
  def test_children_in_poverty_class_exists
    assert FreeLunch
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => 0.513, 2008 => 0.475 }
    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', f.name
    assert_equal data, f.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    f = FreeLunch.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', f.name
    assert_equal expected, f.data
  end

  def test_can_get_a_percentage_for_a_specific_year
    data = { 2007 => 0.5153, 2008 => 0.4375, 2009 => 0.56654 }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.515, f.free_or_reduced_price_lunch_percentage_in_year(2007)
    assert_equal 0.437, f.free_or_reduced_price_lunch_percentage_in_year(2008)
    assert_equal 0.566, f.free_or_reduced_price_lunch_percentage_in_year(2009)
  end

  def test_raises_unknown_data_error_if_year_does_not_exist
    data = { 2007 => 0.5153, 2008 => 0.4375, 2009 => 0.56654 }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_percentage_in_year(2015)
    end
  end
end
