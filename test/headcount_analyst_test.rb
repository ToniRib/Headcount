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
end
