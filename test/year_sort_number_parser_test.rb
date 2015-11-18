require 'minitest'
require 'year_sort_number_parser'
require 'pre_processor'

class YearSortNumberParserTest < Minitest::Test
  def parser_prep_lunches
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/free_lunch_tester.csv')
  end

  def test_class_exists
    assert YearSortNumberParser
  end

  def test_breaks_data_by_district_lunches
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_lunches
    data = parser.parse(ruby_rows)
    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end



  def test_breaks_data_by_year_for_each_district
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_lunches
    data = parser.parse(ruby_rows)
    expected = [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007,
                2008, 2009, 2010, 2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_lunch_and_year
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_lunches
    data = parser.parse(ruby_rows)

    assert_equal 195149.0, data['Colorado'][2000][:total]
    assert_equal 0.7143, data['ADAMS COUNTY 14'][2005][:percentage]
  end


end
