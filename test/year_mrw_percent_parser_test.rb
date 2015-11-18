require 'minitest'
require 'year_mrw_percent_parser'
require 'pre_processor'

class YearMRWPercentParserTest < Minitest::Test
  def parser_prep
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/third_grade_tester.csv')
  end

  def test_class_exists
    assert YearMRWPercentParser
  end

  def test_breaks_data_by_district
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = [2008, 2009, 2010, 2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_year_and_subject
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.849

    assert_equal expected, data['ACADEMY 20'][2010][:math]
  end

  def test_can_find_data_by_location_and_year_expect_na
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ACADEMY 20'][2008][:writing]
  end

  def test_can_find_data_by_location_and_year_expect_na_with_div_zero
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ADAMS COUNTY 14'][2010][:math]
  end

  def test_can_find_multiple_pieces_of_data
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected1 = 0.698
    expected2 = 0.476

    assert_equal expected1, data['Colorado'][2010][:reading]
    assert_equal expected2, data['ADAMS COUNTY 14'][2011][:math]
  end

  def test_loads_data_correctly
    parser = YearMRWPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    examined = ruby_rows[rand(2..60)]
    location = examined.row_data[:location]
    subject = examined.row_data[:score].downcase.to_sym
    year = examined.row_data[:timeframe].to_i

    expected = parser.convert_to_float(examined.row_data[:data])

    assert_equal expected, data[location][year][subject]
  end
end
