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

end
