require 'minitest'
require 'enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def kindergarten_test
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_tester.csv"
      }
    })
    er
  end

  def test_class_exists
    assert EnrollmentRepository
  end

  def test_load_data_creates_enrollment_objects
    er = kindergarten_test

    assert_equal 3, er.enrollments.count

    er.enrollments.each do |name, value|
      assert value.is_a?(Enrollment)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, er.enrollments.keys
  end

  def test_can_find_by_district_name
    er = kindergarten_test

    assert_equal "ACADEMY 20", er.find_by_name("ACADEMY 20").name
  end

  def test_can_find_by_other_district_name
    er = kindergarten_test

    assert_equal "COLORADO", er.find_by_name("Colorado").name
  end

  def test_gives_error_if_district_does_not_exist
    er = kindergarten_test

    refute er.find_by_name("XYZ")
  end

  def test_returns_true_if_district_exists
    er = kindergarten_test

    assert er.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
    er = kindergarten_test

    refute er.district_exists?('XYZ')
  end

  def test_loaded_enrollment_objects_have_expected_names
    er = kindergarten_test

    assert_equal 'COLORADO', er.enrollments['COLORADO'].name
  end

  def test_loaded_enrollment_objects_have_expected_data
    er = kindergarten_test
    data = er.enrollments['COLORADO'].kindergarten_participation_in_year(2004)
    assert_equal 0.240 , data
  end

end
