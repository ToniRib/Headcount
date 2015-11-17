require 'minitest'
require 'economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def load_profile_data
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
    ep = load_profile_data
    assert_equal 6, ep.profiles.count

    ep.profiles.each do |name, value|
      assert value.is_a?(EconomicProfile)
    end

    expected_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14",
                     "ADAMS-ARAPAHOE 28J", "AGATE 300", "AGUILAR REORGANIZED 6"]
    assert_equal expected_keys, ep.profiles.keys
  end

  def test_can_find_by_district_name
    ep = load_profile_data
    profile = ep.find_by_name('ACADEMY 20')

    assert_equal 'ACADEMY 20', profile.name
    assert profile.is_a?(EconomicProfile)
  end

  def test_can_find_by_other_district_name
    ep = load_profile_data

    assert_equal 'COLORADO', ep.find_by_name('Colorado').name
  end

  def test_gives_error_if_district_does_not_exist
    ep = load_profile_data

    refute ep.find_by_name('XYZ')
  end

  def test_returns_true_if_district_exists
    ep = load_profile_data

    assert ep.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
    ep = load_profile_data

    refute ep.district_exists?('XYZ')
  end

  def test_loaded_enrollment_objects_have_expected_names
    ep = load_profile_data

    assert_equal 'COLORADO', ep.profiles['COLORADO'].name
  end

  def test_loaded_statewide_objects_have_expected_median_data
    ep = load_profile_data

    data = ep.profiles['ACADEMY 20'].median.data[[2005,2009]]

    assert_equal 85060.0, data
  end

  def test_loaded_statewide_objects_have_expected_subject_eight_grade_data
    skip
    ep = load_profile_data
    data = ep.profiles['ACADEMY 20'].proficient_for_subject_by_grade_in_year(:reading, 8, 2013)
    assert_equal 0.852, data
  end
end
