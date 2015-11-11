require 'kindergarten_participation'
require 'minitest'

class KindergartenParticipationTest < Minitest::Test
  def test_kindergarten_class_exists
    assert KindergartenParticipation
  end

  def test_can_be_initialized_with_data
    data = { 2007 => 0.513, 2008 => 0.475}
    k = KindergartenParticipation.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', k.name
    assert_equal data, k.data
  end

  def test_can_be_initialized_with_no_data

  end

end
