require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearPercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] = row_data
    end

    data
  end

  # def parse(file_name)
  #   data = {}
  #   parse_options = { headers: true, header_converters: :symbol }
  #
  #   CSV.open(file_name, parse_options).each do |line|
  #     year = line[:timeframe].to_i
  #     data[line[:location]] ||= {}
  #     data[line[:location]][year] = convert_to_float(line[:data])
  #   end
  #
  #   data
  # end
end
