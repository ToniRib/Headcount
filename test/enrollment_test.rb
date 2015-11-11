require 'minitest'
require 'enrollment'

class EnrollmentTest < Minitest::Test
  def test_class_exists
    assert Enrollment
  end

  def test_can_initialize_a_new_enrollment_with_kindergarten_data
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 })

    expected_hash = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267 }

    assert_equal 'ACADEMY 20', e.name
    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_can_initialize_a_different_enrollment_with_kindergarten_data
    e = Enrollment.new(:name => 'COLORADO',
                       :kindergarten_participation => { 2010 => 0.4857, 2011 => 0.4832, 2012 => 'N/A' })

    expected_hash = { 2010 => 0.485, 2011 => 0.483, 2012 => 'N/A' }

    assert_equal 'COLORADO', e.name
    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_returns_kindergarten_participation_by_year_truncated
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 })

    expected_hash = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267 }

    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_returns_kindergarten_participation_including_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    expected_hash = { 2010 => 0.391, 2011 => 0.353, 2012 => 'N/A' }

    assert_equal expected_hash, e.kindergarten_participation_by_year
  end

  def test_na_returns_true_if_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert e.na?('N/A')
  end

  def test_na_returns_false_if_not_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    refute e.na?(0.345)
  end

  def test_truncates_decimal_to_three_places_without_rounding
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.345, e.truncate_to_three_decimals(0.345557)
  end

  def test_returns_three_decimal_places_for_the_number_one
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 1.000, e.truncate_to_three_decimals(1)
  end

  def test_truncates_value_if_value_is_not_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.391, e.truncate_value(0.3915)
  end

  def test_returns_na_instead_of_truncating_if_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 'N/A', e.truncate_value('N/A')
  end

  def test_returns_kindergarten_participation_for_specific_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.391, e.kindergarten_participation_in_year(2010)
  end

  def test_returns_kindergarten_participation_for_a_different_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.353, e.kindergarten_participation_in_year(2011)
  end

  def test_returns_kindergarten_participation_as_na_if_data_na_for_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 'N/A', e.kindergarten_participation_in_year(2012)
  end

  def test_returns_kindergarten_participation_as_nil_if_year_does_not_exist
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_nil e.kindergarten_participation_in_year(2020)
  end

  def test_averages_kindergarten_participation_across_all_years
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.890 })

    assert_equal 0.5450200000000001, e.average(:kindergarten_participation)
  end

  def test_average_returns_na_if_all_values_are_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 'N/A', 2011 => 'N/A', 2012 => 'N/A' })

    assert_equal 'N/A', e.average(:kindergarten_participation)
  end

  def test_returns_total_kindergarten_participation
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.890 })

    assert_equal 1.6350600000000002, e.total(:kindergarten_participation)
  end

  def test_returns_total_kindergarten_participation_with_some_nas
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.7450600000000001, e.total(:kindergarten_participation)
  end

  def test_returns_zero_kindergarten_participation_if_all_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 'N/A', 2011 => 'N/A', 2012 => 'N/A' })

    assert_equal 0, e.total(:kindergarten_participation)
  end

  def test_returns_total_number_of_years_if_none_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.890 })

    assert_equal 3, e.count_non_na(:kindergarten_participation)
  end

  def test_returns_total_number_of_non_na_years
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 2, e.count_non_na(:kindergarten_participation)
  end

  def test_returns_zero_years_if_all_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 'N/A', 2011 => 'N/A', 2012 => 'N/A' })

    assert_equal 0, e.count_non_na(:kindergarten_participation)
  end

  def test_can_initialize_a_new_enrollment_with_highschool_grad_only_data
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 })

    expected_hash = { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 }

    expected_empty = {}

    assert_equal 'ACADEMY 20', e.name
    assert_equal expected_hash, e.high_school_graduation
    assert_equal expected_empty, e.kp.data
  end

  def test_can_initialize_a_new_enrollment_with_highschool_and_kindergarten_data
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' },
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 })

    expected_highschool = { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 }
    expected_kindergarten = { 2010 => 0.391, 2011 => 0.353, 2012 => 'N/A' }

    assert_equal 'ACADEMY 20', e.name
    assert_equal expected_highschool, e.high_school_graduation
    assert_equal expected_kindergarten, e.kindergarten_participation_by_year
  end

  def test_returns_graduation_rate_by_year_truncated
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' },
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 })

    expected_hash = { 2010 => 0.391, 2011 => 0.353, 2012 => 0.267 }

    assert_equal expected_hash, e.graduation_rate_by_year
  end

  def test_returns_graduation_rate_including_na
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    expected_hash = { 2010 => 0.391, 2011 => 0.353, 2012 => 'N/A' }

    assert_equal expected_hash, e.graduation_rate_by_year
  end

  def test_returns_graduation_rate_for_specific_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :high_school_graduation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.391, e.graduation_rate_in_year(2010)
  end

  def test_returns_graduation_rate_for_a_different_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :kindergarten_participation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' },
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 0.353, e.graduation_rate_in_year(2011)
  end

  def test_returns_graduation_rate_as_na_if_data_na_for_year
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_equal 'N/A', e.graduation_rate_in_year(2012)
  end

  def test_returns_graduation_rate_as_nil_if_year_does_not_exist
    e = Enrollment.new(:name => 'ACADEMY 20',
                       :high_school_graduation => { 2010 => 0.3915, 2011 => 0.35356, 2012 => 'N/A' })

    assert_nil e.graduation_rate_in_year(2020)
  end

  def test_returns_nil_for_all_queries_if_input_data_is_garbage
    e = Enrollment.new(:peace  => 4,
                       :coolio => { 2010 => 'hello', :sty => 'hi', 2012 => 'N/A' })

    empty_hash = {}

    assert_nil e.graduation_rate_in_year(2012)
    assert_equal empty_hash, e.graduation_rate_by_year

    assert_nil e.kindergarten_participation_in_year(2010)
    assert_equal empty_hash, e.kindergarten_participation_by_year
  end
end
