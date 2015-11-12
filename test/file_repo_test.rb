require 'file_repo'
require 'minitest/autorun'
require 'pry'

class FileRepoTest < Minitest::Test

  def test_preprocessor_exists
    assert FileRepo
  end

  def test_initializes_without_files
    repo = FileRepo.new

    assert_equal({}, repo.files)
  end

  def test_can_load_test_file
    repo = FileRepo.new
    repo.load_file('./test/fixtures/highschool_grad_tester.csv')
    actual_class = repo.files['./test/fixtures/highschool_grad_tester.csv'].class

    assert_equal Array, actual_class
    expected_headers = [:location, :timeframe, :dataformat, :data]
    actual_headers = repo.files['./test/fixtures/highschool_grad_tester.csv'][0].headers
    assert_equal expected_headers, actual_headers
  end

  def test_can_load_second_test_file
    repo = FileRepo.new
    repo.load_file('./test/fixtures/highschool_grad_tester.csv')
    repo.load_file('./test/fixtures/kindergarten_tester.csv')
    actual_class1 = repo.files['./test/fixtures/highschool_grad_tester.csv'].class
    actual_class2 = repo.files['./test/fixtures/kindergarten_tester.csv'].class

    assert_equal Array, actual_class1
    assert_equal Array, actual_class2

    expected_headers = [:location, :timeframe, :dataformat, :data]
    actual_headers1 = repo.files['./test/fixtures/highschool_grad_tester.csv'][0].headers
    actual_headers2 = repo.files['./test/fixtures/kindergarten_tester.csv'][0].headers


    assert_equal expected_headers, actual_headers1
    assert_equal expected_headers, actual_headers2
  end

end
