require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearSortNumberParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}

    ruby_rows.each do |csv_row|
      next if poverty_to_sym[csv_row.row_data[:poverty_level]] != :free_or_reduced
      data_format = num_to_total[csv_row.row_data[:dataformat]]
      year = csv_row.row_data[:timeframe].to_i
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][data_format] ||= row_data
    end

    data
  end

  def num_to_total
    {"Number" => :total, "Percent" => :percentage}
  end

  def poverty_to_sym
    symbols = [:free, :reduced, :free_or_reduced]
    strings = ['Eligible for Free Lunch', 'Eligible for Reduced Price Lunch',
               'Eligible for Free or Reduced Lunch']

    strings.zip(symbols).to_h
  end
end
