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

  def load_unusual_grade_entries
    options = { :statewide_testing =>
                {
                  :third_grade => "./test/fixtures/unusual_grade_data_tester.csv"
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

  def test_growth_by_grade_math
    ha = load_district_repo_multi_class
    top = ha.top_statewide_test_year_over_year_growth(grade:3, subject: :math)

    assert_equal ["COLORADO", 0.002], top
  end

  def test_growth_by_grade_reading
    ha = load_district_repo_multi_class
    top = ha.top_statewide_test_year_over_year_growth(grade:3, subject: :reading)

    assert_equal ["COLORADO", 0.001], top
  end

  def test_growth_by_grade_reading_top_2
    ha = load_district_repo_multi_class
    top = ha.top_statewide_test_year_over_year_growth(grade:3, top:2, subject: :reading)

    assert_equal [["COLORADO", 0.001], ["ACADEMY 20", -0.006]], top
  end

  def test_growth_by_grade_reading_more_than_there_are
    ha = load_district_repo_multi_class
    top = ha.top_statewide_test_year_over_year_growth(grade:3, top:6, subject: :reading)

    assert_equal [["COLORADO", 0.001], ["ACADEMY 20", -0.006], ["ADAMS COUNTY 14", -0.008]], top
  end

  def test_growth_by_grade_insufficient_data
    ha = load_unusual_grade_entries
    top = ha.top_statewide_test_year_over_year_growth(grade:3, subject: :writing)

    assert_equal [:error,"No districts have sufficient data!"], top
  end

  def test_growth_by_grade_only_one_with_data
    ha = load_unusual_grade_entries
    top = ha.top_statewide_test_year_over_year_growth(grade:3, subject: :reading)

    assert_equal ["COLORADO", -0.158], top
  end


  def test_growth_by_grade_impossible_grade
    ha = load_district_repo_multi_class

    exception = assert_raises(UnknownDataError) { ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)}
  end

  def test_growth_by_grade_impossible_without_both_grade_and_subject
    ha = load_district_repo_multi_class

    assert_raises(InsufficientInformationError) { ha.top_statewide_test_year_over_year_growth(subject: :math)}
  end

  def test_overall_growth_scores_multi_subject
    ha = load_district_repo_multi_class
    expected = {"COLORADO" => 0.001,
                "ACADEMY 20" => -0.008,
                "ADAMS COUNTY 14" => -0.013}
    assert_equal expected, ha.list_scores_by_overall(grade: 3)
  end

  def test_overall_growth_scores_multi_subject_unusual_data
    ha = load_unusual_grade_entries
    expected = {"COLORADO" => -66666.72,
                "ACADEMY 20" => -100000.0,
                "ADAMS COUNTY 14" => -100000.0}
    assert_equal expected, ha.list_scores_by_overall(grade: 3)
  end

  def test_top_overall_growth_scores_multi_subject
    ha = load_district_repo_multi_class
    expected = ["COLORADO" ,0.001]
    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_top_overall_growth_unusual_data
    ha = load_unusual_grade_entries
    expected = [:error, "No districts have sufficient data!"]
    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3)
  end
end
