require 'minitest'
require 'headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  def load_district_repo
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => './test/fixtures/kindergarten_tester.csv',
        :high_school_graduation => './test/fixtures/highschool_grad_tester.csv'
      }
    })
    HeadcountAnalyst.new(dr)
  end

  def load_long_district_repo
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => './test/fixtures/kindergarten_long_tester.csv',
        :high_school_graduation => './test/fixtures/highschool_grad_long_tester.csv'
      }
    })
    HeadcountAnalyst.new(dr)
  end

  def load_district_repo_multi_class
    options = {
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_tester.csv",
        :high_school_graduation => "./test/fixtures/highschool_grad_tester.csv"
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/third_grade_tester.csv",
        :math => "./test/fixtures/math_average_proficiency_tester.csv"
      }
    }

    dr = DistrictRepository.new
    dr.load_data(options)
    HeadcountAnalyst.new(dr)
  end

  def test_class_exists
    assert HeadcountAnalyst
  end

  def test_can_find_enrollment_object_by_district_name
    ha = load_district_repo
    enrollment = ha.find_enrollment_by_name('ACADEMY 20')

    assert_equal 'ACADEMY 20', enrollment.name
    assert_equal 0.436, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_calculates_kindergarten_participation_rate_variation
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.837, var
  end

  def test_calculates_kindergarten_participation_rate_variation_down_case_second
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'Colorado')
    assert_equal 0.837, var
  end

  def test_calculates_kindergarten_participation_rate_variation_down_case_both
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation('Academy 20', :against => 'colorado')
    assert_equal 0.837, var
  end

  def test_calculates_kindergarten_participation_district_against_district
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')
    assert_equal 0.620, var
  end

  def test_calculates_kindergarten_participation_district_against_district_reverse
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'ACADEMY 20')
    assert_equal 1.612, var
  end

  def test_calculates_highschool_graudation_rate_variation
    ha = load_district_repo
    var = ha.highschool_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.195, var
  end

  def test_calculates_kindergarten_participation_rate_variation
    ha = load_district_repo
    var = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    expected = { 2007 => 0.992, 2006 => 'N/A', 2005 => 0.96, 2004 => 1.257,
                 2008 => 0.717, 2009 => 0.652, 2010 => 0.681 }

    assert_equal expected, var
  end

  def test_calculates_kindergarten_graudation_variance
    ha = load_district_repo
    var = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.700, var
  end

  def test_calculates_kindergarten_graudation_variance_for_different_district
    ha = load_district_repo
    var = ha.kindergarten_participation_against_high_school_graduation('ADAMS COUNTY 14')
    assert_equal 1.656, var
  end

  def test_participation_correlates_with_hs_graduation
    ha = load_district_repo
    cor = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    assert cor
  end

  def test_participation_does_not_correlate_with_hs_graduation
    ha = load_district_repo
    cor = ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ADAMS COUNTY 14')
    refute cor
  end

  def test_participation_does_not_correlate_with_range
    ha = load_district_repo
    cor = ha.kgp_correlates_with_hgr_range(['ADAMS COUNTY 14', 'ACADEMY 20'])

    refute cor
  end

  def test_participation_does_not_correlate_with_high_school_graduation_across
    ha = load_long_district_repo
    options = { across: ['ADAMS COUNTY 14', 'ACADEMY 20', 'AGUILAR REORGANIZED 6', 'WESTMINSTER 50'] }
    cor = ha.kindergarten_participation_correlates_with_high_school_graduation(options)

    refute cor
  end

  def test_participation_correlates_with_high_school_graduation_across
    ha = load_district_repo
    options = { across: ['ACADEMY 20'] }
    cor = ha.kindergarten_participation_correlates_with_high_school_graduation(options)

    assert cor
  end

  def test_participation_correlates_with_high_school_graduation_colorado
    ha = load_long_district_repo
    options = { for: 'COLORADO' }
    cor = ha.kindergarten_participation_correlates_with_high_school_graduation(options)

    refute cor
  end

  def test_calculate_ratio_returns_ratio_of_two_values
    ha = load_district_repo

    assert_equal 0.500, ha.calculate_ratio(1, 2)
  end

  def test_calculate_ratio_returns_na_if_second_value_is_na
    ha = load_district_repo

    assert_equal 'N/A', ha.calculate_ratio(1, 'N/A')
  end

  def test_calculate_ratio_returns_na_if_second_value_is_na
    ha = load_district_repo

    assert_equal 'N/A', ha.calculate_ratio('N/A', 1)
  end

  def test_calculate_ratio_returns_na_if_both_values_na
    ha = load_district_repo

    assert_equal 'N/A', ha.calculate_ratio('N/A', 'N/A')
  end

  def test_number_is_within_correlation_range
    ha = load_district_repo

    assert ha.in_correlation_range?(0.8)
  end

  def test_number_is_on_low_edge_of_correlation_range
    ha = load_district_repo

    assert ha.in_correlation_range?(0.6)
  end

  def test_number_is_on_high_edge_of_correlation_range
    ha = load_district_repo

    assert ha.in_correlation_range?(1.5)
  end

  def test_number_is_below_correlation_range
    ha = load_district_repo

    refute ha.in_correlation_range?(0.2)
  end

  def test_number_is_above_correlation_range
    ha = load_district_repo

    refute ha.in_correlation_range?(1.6)
  end

  def test_growth_value_over_range
    input = {2001 => 1, 2002 => 2, 2003 => 3, 2004 => 4}
    ha = HeadcountAnalyst.new
    expected = 0.75

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_over_constant_range
    x = rand(0..100)
    input = {2001 => x, 2002 => x, 2003 => x, 2004 => x}
    ha = HeadcountAnalyst.new
    expected = 0

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_one_item
    input = {2001 => 3}
    ha = HeadcountAnalyst.new
    expected = ha.not_enough_data

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_growth_value_no_items
    input = {}
    ha = HeadcountAnalyst.new
    expected = ha.not_enough_data

    assert_equal expected, ha.growth_value_over_range(input)
  end

  def test_pulls_largest_growth_value
    input = [[3,"COLORADO"],[4,"HIGLAND"],[2,"HEY TONI!!!"]]
    ha = HeadcountAnalyst.new
    expected = ["HIGLAND",4]

    assert_equal expected, ha.return_largest_growth_value(input)
  end

  def test_pulls_largest_growth_values
    input = [[3,"COLORADO"],[4,"HIGLAND"],[2,"HEY TONI!!!"],[6,"AHHHH"]]
    ha = HeadcountAnalyst.new
    expected = [["AHHHH",6],["HIGLAND",4]]

    assert_equal expected, ha.return_largest_growth_value(input,2)
  end

  def test_pulls_largest_growth_value_with_no_datas
    ha = HeadcountAnalyst.new
    input = [[ha.not_enough_data,"COLORADO"],[ha.not_enough_data,"HIGLAND"],[2,"HEY TONI!!!"]]
    expected = ["HEY TONI!!!",2]

    assert_equal expected, ha.return_largest_growth_value(input)
  end

  def test_growth_by_grade_in_math
    ha = load_district_repo_multi_class
    top_growth = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)

    assert_equal ["COLORADO", 0.002], top_growth
  end


  def test_growth_by_grade_no_data
    ha = load_district_repo_multi_class
    top_growth = ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)

    assert_equal "N/A, no districts with sufficient data", top_growth
  end

  def test_growth_by_grade_impossible_grade
    ha = load_district_repo_multi_class

    exception = assert_raises(UnknownDataError) { ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)}
  end

  def test_growth_by_grade_impossible_without_both_grade_and_subject
    ha = load_district_repo_multi_class

    assert_raises(InsufficientInformationError) { ha.top_statewide_test_year_over_year_growth(grade: 3)}
    assert_raises(InsufficientInformationError) { ha.top_statewide_test_year_over_year_growth(subject: :math)}
  end
end
