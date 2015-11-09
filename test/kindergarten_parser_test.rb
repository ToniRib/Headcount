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

  def test_breaks_data_by_year_for_each_district
    kinder = KindergartenParser.new
    data = kinder.parse('./test/fixtures/kindergarten_tester.csv')

    expected = %w{2004 2005 2006 2007 2008 2009 2010}

    assert_equal expected, data['Colorado'].keys.sort
  end


end
