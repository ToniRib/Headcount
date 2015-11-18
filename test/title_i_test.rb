require 'title_i'
require 'minitest'

class TitleITest < Minitest::Test
  def test_children_in_poverty_class_exists
    assert TitleI
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => 0.513, 2008 => 0.475 }
    t = TitleI.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', t.name
    assert_equal data, t.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    t = TitleI.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', t.name
    assert_equal expected, t.data
  end


  def test_can_get_title_i_by_year
    data = { 2007 =>  0.0365,
             2008 =>  0.27435,
             2009 => 0.2138 }

    t = TitleI.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.036, t.title_i_in_year(2007)
  end

  def test_title_i_in_year_returns_exception_if_year_does_not_exist
    data = { 2007 =>  0.0365,
             2008 => 0.27435,
             2009 =>  0.2138 }

    t = TitleI.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) { t.title_i_in_year(2011) }
  end
end
