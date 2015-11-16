require 'minitest'
require 'year_race_number_parser'

class YearRaceNumberParserTest < Minitest::Test
  def parser_prep
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/pupil_enrollment_race_ethnicity_tester.csv')
  end

  def test_class_exists
    assert YearRaceNumberParser
  end

  def test_breaks_data_by_district
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = [2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_race_and_year
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.4205

    assert_equal 1674.0, data['ACADEMY 20'][2007][:hispanic][:number]
    assert_equal 0.08, data['ACADEMY 20'][2007][:hispanic][:percent]
  end

  def test_can_find_data_by_location_year_and_race_expect_na
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    assert_equal "N/A", data['ADAMS COUNTY 14'][2007][:pacific_islander][:number]
    assert_equal "N/A", data['ADAMS COUNTY 14'][2007][:pacific_islander][:percent]
  end

  def test_can_find_multiple_pieces_of_data
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected1 = 0.6585
    expected2 = "N/A"

    assert_equal 0.01, data['Colorado'][2007][:native_american][:percent]
    assert_equal 1179, data['ACADEMY 20'][2008][:asian][:number]
  end

  def test_loads_data_correctly_random_test
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    examined = ruby_rows[rand(2..60)]
    location = examined.row_data[:location]
    race = parser.race_to_sym[examined.row_data[:race]]
    year = examined.row_data[:timeframe].to_i
    data_format = examined.row_data[:dataformat].downcase.to_sym

    expected = parser.convert_to_float(examined.row_data[:data])

    assert_equal expected, data[location][year][race][data_format]
  end
end
