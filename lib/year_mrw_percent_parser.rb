require 'csv'
require_relative 'data_formattable'

class YearMRWPercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    
    ruby_rows.each do |csv_row|
      row_data = convert_to_float(csv_row.row_data[:data])

      data[location(csv_row)] ||= {}
      data[location(csv_row)][year(csv_row)] ||= {}
      data[location(csv_row)][year(csv_row)][subject(csv_row)] = row_data
    end

    data
  end

  def subject(csv_row)
    csv_row.row_data[:score].downcase.to_sym
  end

  def location(csv_row)
    csv_row.row_data[:location]
  end

  def year(csv_row)
    csv_row.row_data[:timeframe].to_i
  end
end
