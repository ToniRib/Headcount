require 'minitest'
require 'enrollment_repository'

class PostProcessorTest < Minitest::Test

  def load_enrollment_repo
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_tester.csv",
        :high_school_graduation => "./test/fixtures/highschool_grad_tester.csv"
      }
    })
    er
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

    assert_nil post.get_year_percent_data(nil)
  end

  def test_inserts_empty_hash_leaves_where_otherwise_nil
    post = PostProcessor.new
    h = { i1: { q1: 1, q2:2 }, i2: { q1: 3, q2: 4} }
    leaved = post.hash_leaves_go_empty_hashes(h)

    assert({}, h[:i3])

  end

end
