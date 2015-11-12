require 'minitest'
require 'enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  def load_enrollment_repo
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => './test/fixtures/kindergarten_tester.csv',
        :high_school_graduation => './test/fixtures/highschool_grad_tester.csv'
      }
    })
    er
  end

  def test_class_exists
    assert EnrollmentRepository
  end

  def test_load_data_creates_enrollment_objects
    er = load_enrollment_repo

    assert_equal 3, er.enrollments.count

    er.enrollments.each do |name, value|
      assert value.is_a?(Enrollment)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, er.enrollments.keys
  end

  def test_can_find_by_district_name
    er = load_enrollment_repo

    assert_equal 'ACADEMY 20', er.find_by_name('ACADEMY 20').name
  end

  def test_can_find_by_other_district_name
    er = load_enrollment_repo

    assert_equal 'COLORADO', er.find_by_name('Colorado').name
  end

  def test_gives_error_if_district_does_not_exist
    er = load_enrollment_repo

    refute er.find_by_name('XYZ')
  end

  def test_returns_true_if_district_exists
    er = load_enrollment_repo

    assert er.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
    er = load_enrollment_repo

    refute er.district_exists?('XYZ')
  end

  def test_loaded_enrollment_objects_have_expected_names
    er = load_enrollment_repo

    assert_equal 'COLORADO', er.enrollments['COLORADO'].name
  end

  def test_loaded_enrollment_objects_have_expected_kindergarten_data
    er = load_enrollment_repo
    data = er.enrollments['COLORADO'].kindergarten_participation_in_year(2004)
    assert_equal 0.240, data
  end

  def test_loaded_enrollment_objects_have_expected_high_school_grad_data
    er = load_enrollment_repo
    data = er.enrollments['ACADEMY 20'].graduation_rate_in_year(2011)
    assert_equal 0.895, data
  end

  def test_loaded_enrollment_objects_have_high_school_grad_data_no_kinder
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :high_school_graduation => './test/fixtures/highschool_grad_tester.csv'
      }
    })

    data = er.enrollments['ACADEMY 20'].graduation_rate_in_year(2011)
    assert_equal 0.895, data
    assert_nil er.enrollments['ACADEMY 20'].kindergarten_participation_in_year(2011)
  end
end
