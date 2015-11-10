require 'minitest'
require 'district_repository'

class DistrictRepositoryTest < Minitest::Test
  def kindergarten_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_tester.csv"
      }
    })
    dr
  end

  def test_class_exists
    assert DistrictRepository
  end

  def test_load_data_creates_district_objects
    dr = kindergarten_test

    assert_equal 3, dr.districts.count

    dr.districts.each do |name, value|
      assert value.is_a?(District)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, dr.districts.keys
  end

  def test_can_find_by_district_name
    dr = kindergarten_test

    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").name
  end

  def test_can_find_by_other_district_name
    dr = kindergarten_test

    assert_equal "COLORADO", dr.find_by_name("Colorado").name
  end

  def test_gives_error_if_district_does_not_exist
    dr = kindergarten_test

    refute dr.find_by_name("XYZ")
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

    district = dr.find_by_name("ACADEMY 20")

    assert_equal "ACADEMY 20", district.enrollment.name

    kp2010 = district.enrollment.kindergarten_participation_in_year(2010)

    assert_equal 0.436, kp2010
  end
end
