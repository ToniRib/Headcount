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

end
