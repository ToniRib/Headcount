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

  def test_can_get_proficiency_for_all_races_from_one_year
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

    expected = { asian: 0.284, black: 0.847, pacific_islander: 0.988,
                 hispanic: 0.145, native_american: 0.476,
                 two_or_more: 0.473, white: 0.344 }

    assert_equal expected, r.proficiency_in_year(2007)
  end

  def test_can_get_proficiency_for_all_races_from_a_different_year
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

    expected = { asian: 0.473, black: 0.958, pacific_islander: 'N/A',
                 hispanic: 0.372, native_american: 0.583,
                 two_or_more: 0.375, white: 0.392 }

    assert_equal expected, r.proficiency_in_year(2008)
  end

  def test_gets_proficiency_for_all_years_for_one_race
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

    expected = { 2007 => 0.284, 2008 => 0.473, 2009 => 0.482 }

    assert_equal expected, r.proficiency_by_race_or_ethnicity(:asian)
  end

  def test_gets_proficiency_for_all_years_for_a_different_race
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

    expected = { 2007 => 0.988, 2008 => 'N/A', 2009 => 0.988 }

    assert_equal expected, r.proficiency_by_race_or_ethnicity(:pacific_islander)
  end

  def test_returns_unknown_race_error_if_race_does_not_exist
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

    exception = assert_raises(UnknownRaceError) { r.proficiency_by_race_or_ethnicity(:purple) }
  end

  def test_returns_proficiency_by_race_for_specific_year
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

    assert_equal 0.847, r.proficiency_by_race_in_year(:black, 2007)
  end

  def test_returns_proficiency_by_race_for_specific_different_year
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

    assert_equal 0.594, r.proficiency_by_race_in_year(:black, 2009)
  end

  def test_returns_proficiency_for_a_different_race_for_specific_year
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

    assert_equal 'N/A', r.proficiency_by_race_in_year(:pacific_islander, 2008)
  end

  def test_returns_proficiency_for_a_different_race_for_specific_different_year
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

    assert_equal 0.988, r.proficiency_by_race_in_year(:pacific_islander, 2009)
  end

  def test_returns_unknown_data_error_for_year_proficiency_if_race_does_not_exist
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

    exception = assert_raises(UnknownDataError) { r.proficiency_by_race_in_year(:purple, 2007) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_returns_unknown_data_error_for_year_proficiency_if_year_does_not_exist
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

    exception = assert_raises(UnknownDataError) { r.proficiency_by_race_in_year(:hispanic, 2027) }
  end
end
