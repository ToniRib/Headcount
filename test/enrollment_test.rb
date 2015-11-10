require 'minitest'
require 'enrollment'

class EnrollmentTest < Minitest::Test
  def test_class_exists
    assert Enrollment
  end

  def test_can_initialize_a_new_enrollment_with_data
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    expected_hash = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal "ACADEMY 20", e.name
    assert_equal expected_hash, e.kindergarten_participation
  end

  def test_can_initialize_a_different_enrollment_with_data
    e = Enrollment.new({:name => "COLORADO", :kindergarten_participation => {2010 => 0.4857, 2011 => 0.4832, 2012 => 'N/A'}})

    expected_hash = {2010 => 0.4857, 2011 => 0.4832, 2012 => 'N/A'}

    assert_equal "COLORADO", e.name
    assert_equal expected_hash, e.kindergarten_participation
  end

  def test_returns_kindergarten_participation_by_year_truncated
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    expected_hash = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}

    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_returns_kindergarten_participation_including_na
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    expected_hash = {2010 => 0.391, 2011 => 0.353, 2012 => 'N/A'}

    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_returns_true_if_na
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert e.is_na?('N/A')
  end

  def test_returns_false_if_not_na
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    refute e.is_na?(0.345)
  end

  def test_truncates_decimal_to_three_places
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 0.345, e.truncate_to_three_decimals(0.345557)
  end

  def test_returns_three_decimal_places_with_one
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 1.000, e.truncate_to_three_decimals(1)
  end

  def test_truncates_value_if_not_na
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 0.391, e.truncate_value(0.3915)
  end

  def test_returns_na_instead_of_truncating_if_na
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 'N/A', e.truncate_value('N/A')
  end

  def test_returns_participation_for_specific_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_returns_participation_for_a_different_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 0.353, e.kindergarten_participation_in_year(2011)
  end

  def test_returns_participation_as_na_if_data_is_na_for_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal 'N/A', e.kindergarten_participation_in_year(2012)
  end

  def test_returns_participation_as_nil_if_year_does_not_exist
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A'}})

    assert_equal nil, e.kindergarten_participation_in_year(2020)
  end
end
