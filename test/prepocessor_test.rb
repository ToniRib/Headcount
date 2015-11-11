require 'preprocessor'
require 'minitest/autorun'
require 'pry'

class PreprocessorTest < Minitest::Test

  def test_preprocessor_exists
    assert Preprocessor
  end

  def test_initializes
    assert Preprocessor.new
  end

  def test_can_read_in_csv_file
    pre = Preprocessor.new
    ruby_csv = pre.pull_from_CSV('./test/fixtures/kindergarten_tester.csv')
    ruby_csv.each do |row|

      assert_equal CSVRow, row.class
      assert_equal [:location, :timeframe, :dataformat, :data], row.headers

    end

    assert_equal 'Colorado', ruby_csv[3].row_data[:location]

  end

end
