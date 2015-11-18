require 'minitest'
require 'year_percent_parser'
require 'pre_processor'

class YearPercentParserTest < Minitest::Test
  def parser_prep
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/kindergarten_tester.csv')
  end

  def parser_prep_school_aged
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/school_aged_children_tester.csv')
  end

  def test_class_exists
    assert YearPercentParser
  end

  def test_breaks_data_by_district
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)

    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = [2004, 2005, 2006, 2007, 2008, 2009, 2010]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_and_year
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.24014

    assert_equal expected, data['Colorado'][2004]
  end

  def test_can_find_data_by_location_and_year_try_two
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 0.30643

    assert_equal expected, data['ADAMS COUNTY 14'][2007]
  end

  def test_recognizes_zero_as_a_number
    parser = YearPercentParser.new
    assert parser.float?('0')
  end

  def test_recognizes_one_as_a_number
    parser = YearPercentParser.new
    assert parser.float?('1')
  end

  def test_recognizes_float_as_a_number
    parser = YearPercentParser.new
    assert parser.float?('0.465')
  end

  def test_rejects_na_as_a_number
    parser = YearPercentParser.new
    refute parser.float?('N/A')
  end

  def test_rejects_div_zero_as_a_number
    parser = YearPercentParser.new
    refute parser.float?('#DIV/0!')
  end

  def test_converts_zero_string_to_float
    parser = YearPercentParser.new
    assert_equal 0.0, parser.convert_to_float('0')
  end

  def test_converts_one_string_to_float
    parser = YearPercentParser.new
    assert_equal 1.0, parser.convert_to_float('1')
  end

  def test_converts_decimal_string_to_float
    parser = YearPercentParser.new
    assert_equal 0.465, parser.convert_to_float('0.465')
  end

  def test_converts_na_to_na
    parser = YearPercentParser.new
    assert_equal 'N/A', parser.convert_to_float('N/A')
  end

  def test_converts_div_by_zero_to_na
    parser = YearPercentParser.new
    assert_equal 'N/A', parser.convert_to_float('#DIV/0!')
  end

  def test_can_find_data_by_location_and_year_expect_na
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ACADEMY 20'][2006]
  end

  def test_can_find_data_by_location_and_year_expect_na_with_div_zero
    parser = YearPercentParser.new
    ruby_rows = parser_prep
    data = parser.parse(ruby_rows)
    expected = 'N/A'

    assert_equal expected, data['ADAMS COUNTY 14'][2005]
  end

  def test_breaks_data_by_school_aged
    parser = YearPercentParser.new
    ruby_rows = parser_prep_school_aged
    data = parser.parse(ruby_rows)
    expected = ['ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_can_find_data_by_location_school_aged_and_year
    parser = YearPercentParser.new
    ruby_rows = parser_prep_school_aged
    data = parser.parse(ruby_rows)

    assert_equal 0.042, data['ACADEMY 20'][2005]
  end
end
