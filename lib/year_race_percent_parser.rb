require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearRacePercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      race = race_to_sym[csv_row.row_data[:race_ethnicity]]
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][race] = row_data
    end

    data
  end

  def race_to_sym
    symbols = [:all, :asian, :black, :pacific_islander,
               :hispanic, :native_american, :two_or_more, :white]
    strings = ['All Students', 'Asian', 'Black', 'Hawaiian/Pacific Islander',
               'Hispanic', 'Native American', 'Two or more', 'White']
    strings.zip(symbols).to_h
  end
end
