require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearRacePercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      race = csv_row.row_data[:race_ethnicity].to_s

      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][race] = row_data
    end
    
    data
  end
end
