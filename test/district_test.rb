require 'minitest'
require 'district'

class DistrictTest < Minitest::Test
  def test_class_exists
    assert District
  end

  def test_can_set_name_of_new_district
    d = District.new(name: 'HEY')

    assert_equal 'HEY', d.name
  end

  def test_can_set_name_of_other_new_district
    d = District.new(name: 'HELLO')

    assert_equal 'HELLO', d.name
  end
end
