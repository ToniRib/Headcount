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
end
