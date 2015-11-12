require 'file_repo'
require 'minitest/autorun'
require 'pry'

class FileRepoTest < Minitest::Test

  def test_preprocessor_exists
    assert FileRepo
  end

  def test_initializes_without_files
    repo = FileRepo.new

    assert_nil repo.kindergarten_participation
  end

  def test_can_load_test_file
    repo = FileRepo.new
    repo.load_file('./test/fixtures/highschool_grad_tester.csv')

    assert_equal Array, repo.high_school_graduation.class
    assert_equal [:location, :timeframe, :dataformat, :data], repo.high_school_graduation[0].headers
  end

  def test_can_load_second_test_file
    repo = FileRepo.new
    repo.load_file('./test/fixtures/highschool_grad_tester.csv')
    repo.load_file('./test/fixtures/kindergarten_tester.csv')

    assert_equal Array, repo.high_school_graduation.class
    assert_equal [:location, :timeframe, :dataformat, :data], repo.high_school_graduation[14].headers

    assert_equal Array, repo.kindergarten_participation.class
    assert_equal [:location, :timeframe, :dataformat, :data], repo.kindergarten_participation[10].headers
    assert_equal "Colorado", repo.kindergarten_participation[5].row_data[:location]
  end

end
