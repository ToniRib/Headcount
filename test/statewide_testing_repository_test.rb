require 'minitest'
require 'statewide_testing_repository'

class StatewideTestRepositoryTest < Minitest::Test
  def load_statewide_repo
  sw = StatewideTestRepository.new
  sw.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/third_grade_tester.csv",
        :eighth_grade => "./test/fixtures/eighth_grade_tester.csv",
        :math => "./test/fixtures/math_average_proficiency_tester.csv"
      }
    })
  sw
  end

  def test_class_exists
    assert StatewideTestRepository
  end

  def test_load_data_creates_statewide_objects
  sw = load_statewide_repo

    assert_equal 3, sw.statewide_tests.count

    sw.statewide_tests.each do |name, value|
      assert value.is_a?(StatewideTest)
    end

    expected_keys = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, sw.statewide_tests.keys
  end

  def test_can_find_by_district_name
  sw = load_statewide_repo

    assert_equal 'ACADEMY 20', sw.find_by_name('ACADEMY 20').name
  end

  def test_can_find_by_other_district_name
  sw = load_statewide_repo

    assert_equal 'COLORADO', sw.find_by_name('Colorado').name
  end

  def test_gives_error_if_district_does_not_exist
  sw = load_statewide_repo

    refute sw.find_by_name('XYZ')
  end

  def test_returns_true_if_district_exists
  sw = load_statewide_repo

    assert sw.district_exists?('Colorado')
  end

  def test_returns_false_if_district_does_not_exist
  sw = load_statewide_repo

    refute sw.district_exists?('XYZ')
  end

  def test_loaded_enrollment_objects_have_expected_names
  sw = load_statewide_repo

    assert_equal 'COLORADO', sw.statewide_tests['COLORADO'].name
  end

  def test_loaded_statewide_objects_have_expected_subject_third_grade_data
  sw = load_statewide_repo
    data = sw.statewide_tests['COLORADO'].proficient_for_subject_by_grade_in_year(:math, 3, 2012)

    assert_equal 0.710, data
  end

  def test_loaded_statewide_objects_have_expected_subject_eight_grade_data
  sw = load_statewide_repo
    data = sw.statewide_tests['ACADEMY 20'].proficient_for_subject_by_grade_in_year(:reading, 8, 2013)
    assert_equal 0.852, data
  end
end
