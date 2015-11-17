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
end
