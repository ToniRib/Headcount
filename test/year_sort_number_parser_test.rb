require 'minitest'
require 'year_sort_number_parser'

class YearSortNumberParserTest < Minitest::Test
  def parser_prep_enrollment
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/pupil_enrollment_race_ethnicity_tester.csv')
  end

  def parser_prep_lunches
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/free_lunch_tester.csv')
  end

  def parser_prep_school_aged
    pre = Preprocessor.new
    pre.pull_from_csv('./test/fixtures/school_aged_children_tester.csv')
  end

  def test_class_exists
    assert YearSortNumberParser
  end

  def test_breaks_data_by_district
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_enrollment
    data = parser.parse(ruby_rows)
    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_district_lunches
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_lunches
    data = parser.parse(ruby_rows)
    expected = ['Colorado', 'ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_school_aged
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_school_aged
    data = parser.parse(ruby_rows)
    expected = ['ACADEMY 20', 'ADAMS COUNTY 14']

    assert_equal expected, data.keys
  end

  def test_breaks_data_by_year_for_each_district
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_enrollment
    data = parser.parse(ruby_rows)
    expected = [2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014]

    assert_equal expected, data['Colorado'].keys.sort
  end

  def test_can_find_data_by_location_race_and_year
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_enrollment
    data = parser.parse(ruby_rows)

    assert_equal 1674.0, data['ACADEMY 20'][2007][:hispanic][:total]
    assert_equal 0.08, data['ACADEMY 20'][2007][:hispanic][:percent]
  end

  def test_can_find_data_by_location_lunch_and_year
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_lunches
    data = parser.parse(ruby_rows)

    assert_equal 195149.0, data['Colorado'][2000][:free_or_reduced][:total]
    assert_equal 0.6179, data['ADAMS COUNTY 14'][2005][:free][:percent]
  end

  def test_can_find_data_by_location_school_aged_and_year
    parser = YearPercentParser.new
    ruby_rows = parser_prep_school_aged

    data = parser.parse(ruby_rows)
    assert_equal 0.042, data['ACADEMY 20'][2005]
  end

  def test_can_find_data_by_location_year_and_race_expect_na
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_enrollment
    data = parser.parse(ruby_rows)

    assert_equal "N/A", data['ADAMS COUNTY 14'][2007][:pacific_islander][:total]
    assert_equal "N/A", data['ADAMS COUNTY 14'][2007][:pacific_islander][:percent]
  end

  def test_can_find_multiple_pieces_of_data
    parser = YearSortNumberParser.new
    ruby_rows = parser_prep_enrollment
    data = parser.parse(ruby_rows)
    expected1 = 0.6585
    expected2 = "N/A"

    assert_equal 0.01, data['Colorado'][2007][:native_american][:percent]
    assert_equal 1179, data['ACADEMY 20'][2008][:asian][:total]
  end
end
