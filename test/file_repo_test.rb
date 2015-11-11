require 'file_repo'
require 'minitest/autorun'
require 'pry'

class FileRepoTest < Minitest::Test

  def test_preprocessor_exists
    assert FileRepo
  end


end
