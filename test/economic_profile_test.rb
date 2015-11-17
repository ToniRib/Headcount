require 'minitest'
require 'economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def load_statewide_repo
  ep = EconomicProfileRepository.new
  ep.load_data({
    :economic_profile => {
      :median_household_income => "./test/fixtures/median_household_tester.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/free_lunch_tester.csv",
      :children_in_poverty => "./test/fixtures/school_aged_children_tester.csv"
    }})
  ep
  end

  def test_class_exists
    assert EconomicProfileRepository
  end

  def test_load_data_creates_statewide_objects
    skip
  ep = load_statewide_repo
    assert_equal 3, ep.statewide_tests.count

    ep.statewide_tests.each do |name, value|
      assert value.is_a?(StatewideTest)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, ep.statewide_tests.keys
  end

  def test_can_find_by_district_name
    skip
  ep = load_statewide_repo

    assert_equal 'ACADEMY 20', ep.find_by_name('ACADEMY 20').name
  end

  def test_can_find_by_other_district_name
    skip
  ep = load_statewide_repo

    assert_equal 'COLORADO', ep.find_by_name('Colorado').name
  end

  def test_gives_error_if_district_does_not_exist
    skip
  ep = load_statewide_repo

    refute ep.find_by_name('XYZ')
  end

  def test_returns_true_if_district_exists
    skip
  ep = load_statewide_repo

    assert ep.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
    skip
  ep = load_statewide_repo

    refute ep.district_exists?('XYZ')
  end

  def test_loaded_enrollment_objects_have_expected_names
    skip
  ep = load_statewide_repo

    assert_equal 'COLORADO', ep.statewide_tests['COLORADO'].name
  end

  def test_loaded_statewide_objects_have_expected_subject_third_grade_data
    skip
  ep = load_statewide_repo
    data = ep.statewide_tests['COLORADO'].proficient_for_subject_by_grade_in_year(:math, 3, 2012)

    assert_equal 0.710, data
  end

  def test_loaded_statewide_objects_have_expected_subject_eight_grade_data
    skip
  ep = load_statewide_repo
    data = ep.statewide_tests['ACADEMY 20'].proficient_for_subject_by_grade_in_year(:reading, 8, 2013)
    assert_equal 0.852, data
  end
end
