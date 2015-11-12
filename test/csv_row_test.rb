require 'csv_row'
require 'minitest/autorun'

class CSVRowTest < Minitest::Test

  def test_rows_exist
    assert CSVRow
  end

  def test_initiailizes_without_a_row
    row = CSVRow.new

    assert_equal({}, row.row_data)
    assert_equal [], row.headers
  end

  def test_can_load_row_data
    options = {:location=>"Colorado",
               :timeframe=>"2010",
               :dataformat=>"Percent",
               :data=>"0.724"}
    row = CSVRow.new(options)

    assert_equal "Colorado", row.row_data[:location]
    assert_equal "2010", row.row_data[:timeframe]
    assert_equal "Percent", row.row_data[:dataformat]
    assert_equal "0.724", row.row_data[:data]
  end

end
