require 'minitest'
require 'headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  def kindergarten_test
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_tester.csv"
      }
    })
    HeadcountAnalyst.new(dr)
  end

  def test_class_exists
    assert HeadcountAnalyst
  end

  def test_calculates_kindergarten_participation_rate_variation
    ha = kindergarten_test

    var = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')

    assert_equal 0.766, var
  end

  def test_calculates_average_of_kindergarten_participation_by_district
    ha = kindergarten_test

    ha.average('ACADEMY 20', :enrollment, :kindergarten_participation)
  end


end
