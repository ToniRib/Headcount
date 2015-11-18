require 'csv'
require_relative 'data_formattable'

class YearSortNumberParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}

    ruby_rows.each do |row|
      next if not_free_or_reduced_lunch_row(row)
      row_data = convert_to_float(row.row_data[:data])

      data[location(row)] ||= {}
      data[location(row)][year(row)] ||= {}
      data[location(row)][year(row)][format(row)] ||= row_data
    end

    data
  end

  def not_free_or_reduced_lunch_row(csv_row)
    poverty_to_sym[csv_row.row_data[:poverty_level]] != :free_or_reduced
  end

  def format(csv_row)
    num_to_total[csv_row.row_data[:dataformat]]
  end

  def location(csv_row)
    csv_row.row_data[:location]
  end

  def year(csv_row)
    csv_row.row_data[:timeframe].to_i
  end

  def num_to_total
    { 'Number' => :total, 'Percent' => :percentage }
  end

  def poverty_to_sym
    symbols = [:free, :reduced, :free_or_reduced]
    strings = ['Eligible for Free Lunch', 'Eligible for Reduced Price Lunch',
               'Eligible for Free or Reduced Lunch']

    strings.zip(symbols).to_h
  end
end
