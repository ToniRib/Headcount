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
    data = { 2007 => {:> => {:percent => 0.036, :number => "N/A"}},
             2009 => {:> => {:percent => 0.238}}}
    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )


    assert_equal 0.238, c.data[2009][:>][:percent]
    assert_equal "N/A", c.data[2007][:>][:number]
  end

  def test_returns_truncated_participation_with_na
    data = { 2007 => {:> => {:percent => 0.036, :number => "N/A"}},
             2009 => {:> => {:percent => 0.238}}}
    c = ChildrenInPoverty.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.238, c.children_in_poverty_in_year(2009)
  end
end
