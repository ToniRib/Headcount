require 'minitest'
require 'range_currency_parser'
require 'pre_processor'

class RangeCurrencyParserTest < Minitest::Test
  def parser_prep
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/median_household_tester.csv')
  end

  def test_class_exists
    assert RangeCurrencyParser
  end

  def test_breaks_data_by_district
    parser = RangeCurrencyParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14',
                'ADAMS-ARAPAHOE 28J','AGATE 300','AGUILAR REORGANIZED 6']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = RangeCurrencyParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = [[2005, 2009], [2006, 2010], [2007, 2011],
                [2008, 2012], [2009, 2013]]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_and_range
    parser = RangeCurrencyParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    assert_equal 56456.0, data['Colorado'][[2006, 2010]]
  end
end
