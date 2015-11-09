require 'minitest'
require 'kindergarten_parser'

class KindergartenParserTest < Minitest::Test

  def test_class_exists
    assert KindergartenParser
  end

  def test_breaks_data_by_district
    kinder = KindergartenParser.new
    data = kinder.parse('./test/fixtures/kindergarten_tester.csv')

    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

end
