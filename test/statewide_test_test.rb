require 'minitest'
require 'statewide_test'

class StatewideTestTest < Minitest::Test
  def test_class_exists
    assert StatewideTest
  end

  def test_can_initialize_with_third_grade_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = { 2008 => { :math => 0.888, :reading => 0.866, :writing => 0.671 },
                 2009 => { :math => 0.824, :reading => 0.864, :writing => 0.706 },
                 2010 => { :math => 0.824, :reading => 'N/A', :writing => 0.662 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.third.proficiency_by_year
    assert_equal empty, s.eighth.proficiency_by_year
  end

  def test_can_initialize_with_different_third_grade_data
    s = StatewideTest.new(:name => 'COLORADO',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = { 2008 => { :math => 0.948, :reading => 0.896, :writing => 0.441 },
                 2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                 2010 => { :math => 0.649, :reading => 0.227, :writing => 0.682 } }

    empty = {}

    assert_equal 'COLORADO', s.name
    assert_equal expected, s.third.proficiency_by_year
    assert_equal empty, s.eighth.proficiency_by_year
  end

  def test_can_initialize_with_eighth_grade_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = { 2008 => { :math => 0.888, :reading => 0.866, :writing => 0.671 },
                 2009 => { :math => 0.824, :reading => 0.864, :writing => 0.706 },
                 2010 => { :math => 0.824, :reading => 'N/A', :writing => 0.662 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.eighth.proficiency_by_year
    assert_equal empty, s.third.proficiency_by_year
  end

  def test_can_initialize_with_different_eighth_grade_data
    s = StatewideTest.new(:name => 'COLORADO',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = { 2008 => { :math => 0.948, :reading => 0.896, :writing => 0.441 },
                 2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                 2010 => { :math => 0.649, :reading => 0.227, :writing => 0.682 } }

    empty = {}

    assert_equal 'COLORADO', s.name
    assert_equal expected, s.eighth.proficiency_by_year
    assert_equal empty, s.third.proficiency_by_year
  end

  def test_can_initialize_with_both_third_and_eighth_grade_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    third_expected = { 2008 => { :math => 0.948, :reading => 0.896, :writing => 0.441 },
                       2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                       2010 => { :math => 0.649, :reading => 0.227, :writing => 0.682 } }

    eighth_expected = { 2008 => { :math => 0.888, :reading => 0.866, :writing => 0.671 },
                        2009 => { :math => 0.824, :reading => 0.864, :writing => 0.706 },
                        2010 => { :math => 0.824, :reading => 'N/A', :writing => 0.662 } }

    assert_equal 'ACADEMY 20', s.name
    assert_equal third_expected, s.third.proficiency_by_year
    assert_equal eighth_expected, s.eighth.proficiency_by_year
  end

  def test_can_return_proficiency_for_third_grade_if_data_exists
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = { 2008 => { :math => 0.948, :reading => 0.896, :writing => 0.441 },
                 2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                 2010 => { :math => 0.649, :reading => 0.227, :writing => 0.682 } }

    assert_equal expected, s.proficient_by_grade(3)
  end

  def test_can_return_proficiency_for_eighth_grade_if_data_exists
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = { 2008 => { :math => 0.888, :reading => 0.866, :writing => 0.671 },
                 2009 => { :math => 0.824, :reading => 0.864, :writing => 0.706 },
                 2010 => { :math => 0.824, :reading => 'N/A', :writing => 0.662 } }

    assert_equal expected, s.proficient_by_grade(8)
  end

  def test_returns_empty_hash_for_proficient_by_grade_if_third_grade_data_does_not_exist
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = {}

    assert_equal expected, s.proficient_by_grade(3)
  end

  def test_returns_empty_hash_for_proficient_by_grade_if_eighth_grade_data_does_not_exist
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = {}

    assert_equal expected, s.proficient_by_grade(8)
  end

  def test_returns_unknown_data_error_for_proficient_by_grade_if_grade_is_not_third_or_eighth
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    exception = assert_raises(UnknownDataError) { s.proficient_by_grade(5) }
    assert_equal('Unknown grade requested', exception.message)
  end

  def test_returns_proficiency_for_third_grade_math_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 0.948

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_returns_proficiency_for_third_grade_reading_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 0.896

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:reading, 3, 2008)
  end

  def test_returns_proficiency_for_third_grade_writing_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 0.441

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:writing, 3, 2008)
  end

  def test_returns_proficiency_for_third_grade_math_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 0.724

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:math, 3, 2009)
  end

  def test_returns_proficiency_for_third_grade_reading_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 'N/A'

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:reading, 3, 2009)
  end

  def test_returns_proficiency_for_third_grade_writing_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    expected = 0.526

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:writing, 3, 2009)
  end

  def test_returns_proficiency_for_eighth_grade_math_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 0.888

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
  end

  def test_returns_proficiency_for_eighth_grade_reading_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 0.866

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:reading, 8, 2008)
  end

  def test_returns_proficiency_for_eighth_grade_writing_in_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 0.671

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:writing, 8, 2008)
  end

  def test_returns_proficiency_for_eighth_grade_math_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 0.824

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:math, 8, 2010)
  end

  def test_returns_proficiency_for_eighth_grade_reading_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 'N/A'

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:reading, 8, 2010)
  end

  def test_returns_proficiency_for_eighth_grade_writing_in_different_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = 0.662

    assert_equal expected, s.proficient_for_subject_by_grade_in_year(:writing, 8, 2010)
  end

  def test_returns_unknown_data_error_for_unknown_grade
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_grade_in_year(:math, 5, 2008) }
    assert_equal('Unknown grade requested', exception.message)
  end

  def test_returns_unknown_data_error_for_unknown_subject
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_grade_in_year(:science, 3, 2008) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_returns_unknown_data_error_for_unknown_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } },
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.9483, :reading => 0.896, :writing => 0.44143 },
                              2009 => { :math => 0.724, :reading => 'N/A', :writing => 0.526 },
                              2010 => { :math => 0.64988, :reading => 0.2272, :writing => 0.682 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_grade_in_year(:reading, 3, 2015) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_returns_unknown_data_error_for_proficient_for_subject_if_third_grade_data_does_not_exist
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_grade_in_year(:reading, 3, 2008) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_returns_unknown_data_error_for_proficient_for_subject_if_eighth_grade_data_does_not_exist
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_grade_in_year(:reading, 8, 2008) }
    assert_equal('Data does not exist in dataset', exception.message)
  end

  def test_can_initialize_with_math_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                           hispanic: 0.145, native_american: 0.4763,
                           two_or_more: 0.473, white: 0.3445 },
                 2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                           hispanic: 0.372, native_american: 0.583,
                           two_or_more: 0.3750, white: 0.3928 },
                 2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                           hispanic: 0.377, native_american: 0.988,
                           two_or_more: 0.266, white: 0.4837 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.math.data
    assert_equal empty, s.reading.data
    assert_equal empty, s.writing.data
  end

  def test_can_initialize_with_reading_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :reading =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                           hispanic: 0.145, native_american: 0.4763,
                           two_or_more: 0.473, white: 0.3445 },
                 2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                           hispanic: 0.372, native_american: 0.583,
                           two_or_more: 0.3750, white: 0.3928 },
                 2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                           hispanic: 0.377, native_american: 0.988,
                           two_or_more: 0.266, white: 0.4837 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.reading.data
    assert_equal empty, s.math.data
    assert_equal empty, s.writing.data
  end

  def test_can_initialize_with_writing_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :writing =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                           hispanic: 0.145, native_american: 0.4763,
                           two_or_more: 0.473, white: 0.3445 },
                 2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                           hispanic: 0.372, native_american: 0.583,
                           two_or_more: 0.3750, white: 0.3928 },
                 2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                           hispanic: 0.377, native_american: 0.988,
                           two_or_more: 0.266, white: 0.4837 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.writing.data
    assert_equal empty, s.reading.data
    assert_equal empty, s.math.data
  end

  def test_can_initialize_with_math_reading_and_writing_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :reading =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :writing =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                           hispanic: 0.145, native_american: 0.4763,
                           two_or_more: 0.473, white: 0.3445 },
                 2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                           hispanic: 0.372, native_american: 0.583,
                           two_or_more: 0.3750, white: 0.3928 },
                 2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                           hispanic: 0.377, native_american: 0.988,
                           two_or_more: 0.266, white: 0.4837 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.math.data
    assert_equal expected, s.reading.data
    assert_equal expected, s.writing.data
  end

  def test_can_initialize_with_all_data
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :eighth_grade_proficiency =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    expected = { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                           hispanic: 0.145, native_american: 0.4763,
                           two_or_more: 0.473, white: 0.3445 } }

    empty = {}

    assert_equal 'ACADEMY 20', s.name
    assert_equal expected, s.math.data
    assert_equal expected, s.reading.data
    assert_equal expected, s.writing.data
    assert_equal expected, s.third.data
    assert_equal expected, s.eighth.data
  end

  def test_returns_proficiency_for_a_race_across_all_years_and_subjects
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :reading =>
                            { 2007 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.377, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.2625, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :writing =>
                            { 2007 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.955, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.379, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => {math: 0.284, reading: 0.473, writing: 0.859},
                 2008 => {math: 0.473, reading: 0.377, writing: 0.473},
                 2009 => {math: 0.482, reading: 0.262, writing: 0.379} }

    assert_equal expected, s.proficient_by_race_or_ethnicity(:asian)
  end

  def test_returns_proficiency_for_a_race_across_all_years_and_subjects_with_missing_years
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :reading =>
                            { 2007 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.377, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.2625, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :writing =>
                            { 2007 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.955, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.379, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    expected = { 2007 => {math: 0.284, reading: 0.473, writing: 0.859},
                 2008 => {math: nil, reading: 0.377, writing: 0.473},
                 2009 => {math: 0.482, reading: 0.262, writing: 0.379} }

    assert_equal expected, s.proficient_by_race_or_ethnicity(:asian)
  end

  def test_returns_unknown_race_error_if_race_does_not_exist
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.48222, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :reading =>
                            { 2007 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.377, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.372, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.2625, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } },
                          :writing =>
                            { 2007 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 },
                              2008 => { asian: 0.473, black: 0.9583, pacific_islander: 'N/A',
                                        hispanic: 0.955, native_american: 0.583,
                                        two_or_more: 0.3750, white: 0.3928 },
                              2009 => { asian: 0.379, black: 0.594, pacific_islander: 0.988,
                                        hispanic: 0.377, native_american: 0.988,
                                        two_or_more: 0.266, white: 0.4837 } })

    exception = assert_raises(UnknownRaceError) { s.proficient_by_race_or_ethnicity(:purple) }
  end

  def test_returns_proficiency_by_race_subject_and_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2007 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2007 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    assert_equal 0.847, s.proficient_for_subject_by_race_in_year(:writing, :black, 2007)
  end

  def test_returns_proficiency_for_different_race_subject_and_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2008 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2008 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2008 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    assert_equal 0.344, s.proficient_for_subject_by_race_in_year(:math, :white, 2008)
  end

  def test_returns_unknown_data_error_for_unknown_year_for_proficient_by_subject_race_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2008 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2008 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2008 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_race_in_year(:math, :white, 2007) }
  end

  def test_returns_unknown_data_error_for_unknown_subject_for_proficient_by_subject_race_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2008 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2008 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2008 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    exception = assert_raises(UnknownDataError) { s.proficient_for_subject_by_race_in_year(:science, :white, 2009) }
  end

  def test_returns_unknown_data_error_for_unknown_race_for_proficient_by_subject_race_year
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :math =>
                            { 2008 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :reading =>
                            { 2008 => { asian: 0.4738, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } },
                          :writing =>
                            { 2008 => { asian: 0.859, black: 0.8473, pacific_islander: 0.9887,
                                        hispanic: 0.145, native_american: 0.4763,
                                        two_or_more: 0.473, white: 0.3445 } })

    assert_raises(UnknownDataError) { s.proficient_for_subject_by_race_in_year(:math, :purple, 2009) }
  end

  def test_calculates_average_percent_growth_for_all_subjects_for_eighth_grade
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = -0.005
    weights = { math: 0.333, reading: 0.333, writing: 0.333 }

    assert_equal expected, s.average_percent_growth_by_grade_all_subjects(8, weights)
  end

  def test_calculates_average_percent_growth_for_all_subjects_for_third_grade
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    expected = -0.005
    weights = { math: 0.333, reading: 0.333, writing: 0.333 }

    assert_equal expected, s.average_percent_growth_by_grade_all_subjects(3, weights)
  end

  def test_returns_unknown_data_error_for_average_percentage_by_year_for_unknown_grade
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    weights = { math: 0.333, reading: 0.333, writing: 0.333 }

    assert_raises(UnknownDataError) { s.average_percent_growth_by_grade_all_subjects(7, weights) }
  end

  def test_returns_unknown_data_error_for_average_percentage_by_year_if_data_not_loaded
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })
    weights = { math: 0.333, reading: 0.333, writing: 0.333 }

    assert_raises(UnknownDataError) { s.average_percent_growth_by_grade_all_subjects(8, weights) }
  end

  def test_calculates_average_percent_growth_for_eighth_grade_math
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :eighth_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    assert_equal -0.032, s.average_percent_growth_by_grade_for_subject(8, :math)
  end

  def test_calculates_average_percent_growth_for_third_grade_reading
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    assert_equal -0.002, s.average_percent_growth_by_grade_for_subject(3, :reading)
  end

  def test_returns_unknown_data_error_for_average_percentage_for_subject_if_year_unknown
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    assert_raises(UnknownDataError) { s.average_percent_growth_by_grade_for_subject(7, :math) }
  end

  def test_returns_unknown_data_error_for_average_percentage_for_subject_if_subject_unknown
    s = StatewideTest.new(:name => 'ACADEMY 20',
                          :third_grade_proficiency =>
                            { 2008 => { :math => 0.88857, :reading => 0.866, :writing => 0.67143 },
                              2009 => { :math => 0.824, :reading => 0.8642, :writing => 0.706 },
                              2010 => { :math => 0.8249, :reading => 'N/A', :writing => 0.662 } })

    assert_raises(UnknownDataError) { s.average_percent_growth_by_grade_for_subject(8, :science) }
  end
end
