require 'minitest'
require 'district_repository'

class DistrictRepositoryTest < Minitest::Test
  def kindergarten_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => './test/fixtures/kindergarten_tester.csv'
      }
    })
    dr
  end

  def full_data_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => './test/fixtures/kindergarten_tester.csv',
        :high_school_graduation => './test/fixtures/highschool_grad_tester.csv'
      },
      :statewide_testing => {
        :third_grade => './test/fixtures/third_grade_tester.csv',
        :eigth_grade => './test/fixtures/eighth_grade_tester.csv',
        :math => './test/fixtures/math_average_proficiency_tester.csv',
        :reading => './test/fixtures/reading_average_proficiency_tester.csv',
        :writing => './test/fixtures/writing_average_proficiency_tester.csv'
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_tester.csv",
        :free_or_reduced_price_lunch => "./test/fixtures/free_lunch_tester.csv",
        :children_in_poverty => "./test/fixtures/school_aged_children_tester.csv"
      }
    })
    dr
  end

  def test_class_exists
    assert DistrictRepository
  end

  def test_load_data_creates_district_objects
    dr = full_data_test
    assert_equal 6, dr.districts.count

    dr.districts.each do |name, value|
      assert value.is_a?(District)
    end

    expected_keys = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14",
                     "ADAMS-ARAPAHOE 28J", "AGATE 300", "AGUILAR REORGANIZED 6"]
    assert_equal expected_keys, dr.districts.keys
  end

  def test_can_find_by_district_name
    dr = kindergarten_test

    assert_equal 'ACADEMY 20', dr.find_by_name('ACADEMY 20').name
  end

  def test_can_find_by_other_district_name
    dr = kindergarten_test

    assert_equal 'COLORADO', dr.find_by_name('Colorado').name
  end

  def test_gives_error_if_district_does_not_exist
    dr = kindergarten_test

    assert_raises (UnknownDataError){ dr.find_by_name('XYZ') }
  end

  def test_returns_true_if_district_exists
    dr = kindergarten_test

    assert dr.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
    dr = kindergarten_test

    refute dr.district_exists?('XYZ')
  end

  def test_returns_empty_array_if_no_districts_include_fragment
    dr = kindergarten_test

    assert_equal [], dr.find_all_matching('frank')
  end

  def test_returns_district_objects_containing_fragment
    dr = kindergarten_test

    districts = dr.find_all_matching('a')

    assert_equal 'ACADEMY 20', districts[0].name
    assert_equal 'ADAMS COUNTY 14', districts[1].name
  end

  def test_loading_data_creates_enrollment_repo_with_data
    dr = kindergarten_test

    assert_equal 3, dr.enrollment_repo.enrollments.count

    dr.enrollment_repo.enrollments.each do |name, value|
      assert value.is_a?(Enrollment)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, dr.enrollment_repo.enrollments.keys
  end

  def test_districts_get_enrollments_after_loading
    dr = kindergarten_test

    district = dr.find_by_name('ACADEMY 20')

    assert_equal 'ACADEMY 20', district.enrollment.name

    kp2010 = district.enrollment.kindergarten_participation_in_year(2010)

    assert_equal 0.436, kp2010
  end

  def test_can_load_enrollment_statewide_and_economic_data
    dr = full_data_test
    computed1 = dr.districts["COLORADO"].economic_profile.median.data[[2005,2009]]
    computed2 = dr.districts["COLORADO"].statewide_test.math.data[2011][:asian]
    computed3 = dr.districts["ACADEMY 20"].enrollment.hs.data[2010]
    computed4 = dr.districts["ACADEMY 20"].economic_profile.lunch.data[2014][:total]

    assert_equal 56222.0, computed1
    assert_equal 0.7094, computed2
    assert_equal 0.895, computed3
    assert_equal 3132.0, computed4
  end

  def test_can_extract_all_names
    dr = full_data_test

    names = dr.district_names_across_repositories

    assert_equal names, dr.economic_profile_repo.profiles.keys
  end
end
