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
    expected = [2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_year_and_subject
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.4205

    assert_equal expected, data['ACADEMY 20'][2014][:black]
  end

  def test_can_find_data_by_location_and_year_expect_na
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    assert_nil data['ACADEMY 20'][2002]
  end

  def test_can_find_data_by_location_and_year_expect_na_with_LNE
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ADAMS COUNTY 14'][2013][:asian]
  end

  def test_can_find_multiple_pieces_of_data
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected1 = 0.6585
    expected2 = "N/A"

    assert_equal expected1, data['Colorado'][2011][:white]
    assert_equal expected2, data['ADAMS COUNTY 14'][2011][:pacific_islander]
  end

  def test_loads_data_correctly
    parser = YearRaceNumberParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    examined = ruby_rows[rand(2..60)]
    location = examined.row_data[:location]
    race = parser.race_to_sym[examined.row_data[:race_ethnicity]]
    year = examined.row_data[:timeframe].to_i

    expected = parser.convert_to_float(examined.row_data[:data])

    assert_equal expected, data[location][year][race]
  end
end
