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

  def load_statewide_testing_repo
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => './test/fixtures/third_grade_long_tester.csv',
        :eighth_grade => './test/fixtures/eighth_grade_long_tester.csv' } })
    HeadcountAnalyst.new(dr)
  end

  def load_full_kindergarden_and_highschool_repos
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => './data/Kindergartners in full-day program.csv',
        :high_school_graduation => './data/High school graduation rates.csv'
      }
    })
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
    ha = load_full_kindergarden_and_highschool_repos
    options = { for: 'STATEWIDE' }
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

  def test_growth_raises_insufficient_info_exception_if_no_grade
    ha = load_statewide_testing_repo

    exception = assert_raises(InsufficientInformationError) { ha.top_statewide_test_year_over_year_growth(hello: 9) }
  end

  def test_calculates_avg_percentage_growth_for_third_grade_math
    ha = load_statewide_testing_repo

    expected = [["ACADEMY 20", -0.0037499999999999942],
                ["ADAMS COUNTY 14", -0.00793166666666667],
                ["ADAMS-ARAPAHOE 28J", 0.004365000000000008],
                ["AGATE 300", nil],
                ["AGUILAR REORGANIZED 6", nil],
                ["AKRON R-1", 0.015491666666666662]]

    assert_equal expected, ha.growth_by_district(grade: 3, subject: :math)
  end

  def test_calculates_avg_percentage_growth_for_eighth_grade_reading
    ha = load_statewide_testing_repo

    expected = [["ACADEMY 20", -0.002666666666666669],
                ["ADAMS COUNTY 14", -0.0008250000000000016],
                ["ADAMS-ARAPAHOE 28J", -0.008666666666666665],
                ["AGATE 300", nil],
                ["AGUILAR REORGANIZED 6", nil],
                ["AKRON R-1", 0.0008883333333333429]]

    assert_equal expected, ha.growth_by_district(grade: 8, subject: :reading)
  end

  def test_sorts_all_non_nil_districts_by_growth
    ha = load_statewide_testing_repo

    original = [['COLORADO', -0.007],
                ['ACADEMY 20', -0.003],
                ['ADAMS COUNTY 14', -0.001],
                ['ADAMS-ARAPAHOE 28J', -0.009],
                ['AGATE 300', nil],
                ['AGUILAR REORGANIZED 6', nil],
                ['AKRON R-1', 0.10]]

    expected = [['AKRON R-1', 0.10],
                ['ADAMS COUNTY 14', -0.001],
                ['ACADEMY 20', -0.003],
                ['COLORADO', -0.007],
                ['ADAMS-ARAPAHOE 28J', -0.009]]

    assert_equal expected, ha.sort_districts_by_growth(original)
  end

  def test_gets_top_growth_in_third_grade_math
    ha = load_statewide_testing_repo

    expected = ['AKRON R-1', 0.015]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_gets_top_growth_in_eighth_grade_reading
    ha = load_statewide_testing_repo

    expected = ['AKRON R-1', 0.000]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading)
  end

  def test_gets_top_three_growth_leaders_in_third_grade_math
    ha = load_statewide_testing_repo

    expected = [['AKRON R-1', 0.015], ['ADAMS-ARAPAHOE 28J', 0.004], ['ACADEMY 20', -0.004]]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math, top: 3)
  end

  def test_returns_top_growth_across_all_subjects_third_grade
    ha = load_statewide_testing_repo

    expected = ['AKRON R-1', 0.024]
    options = { :grade => 3,
                :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0} }

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(options)
  end

  def test_returns_top_growth_across_all_subjects_third_grade_no_weights_specified
    ha = load_statewide_testing_repo

    expected = ['AKRON R-1', 0.009]
    binding.pry
    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_returns_top_two_growth_acorss_all_subjects_with_weights
    ha = load_statewide_testing_repo

    expected = [["AKRON R-1", 0.021], ["ADAMS-ARAPAHOE 28J", 0.002]]
    options = { :grade => 3,
                :weighting => {:math => 0.7, :reading => 0.3, :writing => 0.0},
                :top => 2 }

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(options)
  end

  def test_return_argument_error_if_weights_do_not_add_up_to_one
    ha = load_statewide_testing_repo

    expected = [['AKRON R-1', 0.012], ['ADAMS-ARAPAHOE 28J', 0.001]]
    options = { :grade => 3,
                :weighting => {:math => 0.9, :reading => 0.3, :writing => 0.0},
                :top => 2 }

    assert_raises(ArgumentError) {ha.top_statewide_test_year_over_year_growth(options)}
  end
end
