require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearMRWPercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      subject = csv_row.row_data[:score].downcase.to_sym
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][subject] = row_data
    end
    data
  end
end
