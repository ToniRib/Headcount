require 'minitest'
require 'district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_class_exists
    assert DistrictRepository
  end

  def test_can_load_data_from_kindergarten_file
    dr = DistrictRepository.new
    data = dr.load_data(:kindergarten => "./test/fixtures/kindergarten_tester.csv")

    expected_keys = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, data.keys

    expected_years = [2004, 2005, 2006, 2007, 2008, 2009, 2010]
    assert_equal expected_years, data['Colorado'].keys.sort

    assert_equal 0.24014, data['Colorado'][2004]

    assert_equal 'N/A', data['ADAMS COUNTY 14'][2005]
  end

  def test_load_data_creates_district_objects
    dr = DistrictRepository.new
    data = dr.load_data(:kindergarten => "./test/fixtures/kindergarten_tester.csv")

    assert_equal 3, dr.districts.count

    dr.districts.each do |name, value|
      assert value.is_a?(District)
    end

    expected_keys = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']
    assert_equal expected_keys, dr.districts.keys
  end

  def test_can_find_by_district_name
    dr = DistrictRepository.new
    data = dr.load_data(:kindergarten => "./test/fixtures/kindergarten_tester.csv")

    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").name
  end

  def test_can_find_by_other_district_name
    dr = DistrictRepository.new
    data = dr.load_data(:kindergarten => "./test/fixtures/kindergarten_tester.csv")

    assert_equal "Colorado", dr.find_by_name("Colorado").name
  end

  def test_gives_error_if_district_does_not_exist
    dr = DistrictRepository.new
    data = dr.load_data(:kindergarten => "./test/fixtures/kindergarten_tester.csv")

    expected = "District XYZ does not exist in database"

    assert_equal expected, dr.find_by_name("XYZ")
  end


end
