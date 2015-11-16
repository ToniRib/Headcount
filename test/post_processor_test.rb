require 'minitest'
require 'enrollment_repository'

class PostProcessorTest < Minitest::Test

  def full_options
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
  end

  def test_class_exists
    assert PostProcessor
  end

  def test_transpose_data_transposes_a_nested_hash
    post = PostProcessor.new
    h = { i1: { q1: 1, q2:2 }, i2: { q1: 3, q2: 4} }
    expected = { q1: { i1: 1, i2: 3 }, q2: { i1: 2, i2: 4 } }

    assert_equal expected, post.transpose_data(h)
  end

  def test_transpose_data_transposes_a_nested_hash_when_one_nil
    post = PostProcessor.new
    h = { i1: { q1: 1, q2:2 }, i2: nil }
    expected = { q1: { i1: 1 }, q2: { i1: 2 } }

    assert_equal expected, post.transpose_data(h)
  end

  def test_get_year_returns_nil_if_no_file
    post = PostProcessor.new

    assert_nil post.get_data(:percent,nil)
  end

  def test_inserts_empty_hash_leaves_where_otherwise_nil
    post = PostProcessor.new
    h = { i1: { q1: 1, q2:2 }, i2: { q1: 3, q2: 4} }
    leaved = post.hash_leaves_go_empty_hashes(h)

    assert({}, h[:i3])
  end

  def test_gets_data_from_enrollment_files
    post = PostProcessor.new
    data = post.get_data(:percent,"./test/fixtures/kindergarten_tester.csv")
    expected = 0.39465

    assert_equal expected, data["Colorado"][2007]
  end

  def test_gets_data_from_statewide_test_files
    post = PostProcessor.new
    data = post.get_data(:mrw,"./test/fixtures/third_grade_tester.csv")
    expected = 0.697

    assert_equal expected, data['Colorado'][2008][:math]
  end

  def test_gets_data_from_statewide_test_files_mrw
    post = PostProcessor.new
    data = post.get_data(:mrw,"./test/fixtures/third_grade_tester.csv")
    expected = 0.697

    assert_equal expected, data['Colorado'][2008][:math]
  end

  def test_gets_data_from_statewide_test_files_mrw
    post = PostProcessor.new
    data = post.get_data(:race,"./test/fixtures/math_average_proficiency_tester.csv")
    expected = 0.8169

    assert_equal expected, data["ACADEMY 20"][2011][:asian]
  end


  def test_gets_enrollment_data_from_options
    post = PostProcessor.new
    data = post.get_enrollment_data(full_options)
    expected1 = 0.39465

    assert_equal expected1, data["Colorado"][:kindergarten_participation][2007]

    expected2 = 0.608

    assert_equal expected2, data["ADAMS COUNTY 14"][:high_school_graduation][2011]
  end

  def test_gets_statewide_testing_from_options
    post = PostProcessor.new
    data = post.get_statewide_testing_data(full_options)
    expected1 = 0.697

    assert_equal expected1, data["Colorado"][:third_grade_proficiency][2008][:math]

    expected2 = 0.7094

    assert_equal expected2, data["Colorado"][:math][2011][:asian]
  end
end
