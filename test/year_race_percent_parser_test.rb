require 'minitest'
require 'year_race_percent_parser'

class YearRacePercentParserTest < Minitest::Test
  def parser_prep
    pre = Preprocessor.new
    pre.pull_from_CSV('./test/fixtures/math_average_proficiency_tester.csv')
  end

  def test_class_exists
    assert YearRacePercentParser
  end

  def test_breaks_data_by_district
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = [2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_year_and_subject
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.4205

    assert_equal expected, data['ACADEMY 20'][2014]["Black"]
  end

  def test_can_find_data_by_location_and_year_expect_na
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    
    assert_nil data['ACADEMY 20'][2002]
  end

  def test_can_find_data_by_location_and_year_expect_na_with_LNE
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ADAMS COUNTY 14'][2013]["Asian"]
  end

  def test_can_find_multiple_pieces_of_data
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected1 = 0.6585
    expected2 = "N/A"

    assert_equal expected1, data['Colorado'][2011]["White"]
    assert_equal expected2, data['ADAMS COUNTY 14'][2011]["Hawaiian/Pacific Islander"]
  end

  def test_loads_data_correctly
    parser = YearRacePercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    examined = ruby_rows[rand(2..60)]
    location = examined.row_data[:location]
    race = examined.row_data[:race_ethnicity].to_s
    year = examined.row_data[:timeframe].to_i

    expected = parser.convert_to_float(examined.row_data[:data])

    assert_equal expected, data[location][year][race]
  end
end




# Colorado,White,2012,Percent,0.6618
# Colorado,All Students,2013,Percent,0.5668
# Colorado,Asian,2013,Percent,0.7323
# Colorado,Black,2013,Percent,0.3549
# Colorado,Hawaiian/Pacific Islander,2013,Percent,0.5248
# Colorado,Hispanic,2013,Percent,0.4017
# Colorado,Native American,2013,Percent,0.4065
# Colorado,Two or more,2013,Percent,0.6201
