require 'pry'
require_relative 'data_formattable'

class RangeCurrencyParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}

    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].split("-").map(&:to_i)
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] = row_data
    end

    data
  end
end
