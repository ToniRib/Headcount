require 'minitest'
require 'race_ethnicity_proficiency'

class RaceEthnicityProficiencyTest < Minitest::Test
  def test_class_exists
    assert RaceEthnicityProficiency
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                       hispanic: 0.145, native_american: 0.4763,
                       two_or_more: 0.473, white: 0.3445 },
             2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                       hispanic: 0.372, native_american: 0.583,
                       two_or_more: 0.3750, white: 0.3928 },
             2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                       hispanic: 0.377, native_american: 0.988,
                       two_or_more: 0.266, white: 0.4837 } }

    r = RaceEthnicityProficiency.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', r.name
    assert_equal data, r.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    r = RaceEthnicityProficiency.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', r.name
    assert_equal expected, r.data
  end
end
