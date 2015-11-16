require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearRaceNumberParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}

    ruby_rows.each do |csv_row|
      data_format = csv_row.row_data[:dataformat].downcase.to_sym
      year = csv_row.row_data[:timeframe].to_i
      race = race_to_sym[csv_row.row_data[:race]]
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][race] ||= {}
      data[csv_row.row_data[:location]][year][race][data_format] = row_data
    end

    data
  end

  def race_to_sym
    symbols = [:asian, :black, :pacific_islander,
               :hispanic, :native_american, :two_or_more, :white, :total]
    strings = ['Asian Students', 'Black Students',
               'Native Hawaiian or Other Pacific Islander',
               'Hispanic Students', 'American Indian Students',
               'Two or more races', 'White Students', 'Total']
    strings.zip(symbols).to_h
  end
end
