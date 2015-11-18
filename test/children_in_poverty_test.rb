require 'children_in_poverty'
require 'minitest'

class ChildrenInPovertyTest < Minitest::Test
  def test_children_in_poverty_class_exists
    assert ChildrenInPoverty
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => 0.513, 2008 => 0.475 }
    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', c.name
    assert_equal data, c.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', c.name
    assert_equal expected, c.data
  end

  def test_returns_expected_data
    data = { 2007 => 0.036,
             2009 => 0.238 }

    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )


    assert_equal 0.238, c.data[2009]

    assert_nil c.data[2010]
  end

  def test_returns_data_from_specific_year
    data = { 2007 =>  0.0365,
             2008 =>  0.27435,
             2009 => 0.2138 }

    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.036, c.children_in_poverty_in_year(2007)
    assert_equal 0.274, c.children_in_poverty_in_year(2008)
  end

  def test_children_in_poverty_in_year_returns_exception_if_year_does_not_exist
    data = { 2007 =>  0.0365,
             2008 => 0.27435,
             2009 =>  0.2138 }

    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) { c.children_in_poverty_in_year(2011) }
  end

  def test_children_in_poverty_in_year_returns_exception_if_percent_does_not_exist
    data = { 2007 => 0.0365,
             2008 => 0.27435,
             2009 => 0.2138 }

    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) { c.children_in_poverty_in_year(2010) }
  end
end
