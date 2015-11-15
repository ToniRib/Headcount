require 'csv'
require_relative 'csv_row'

class Preprocessor
  def pull_from_CSV(file_name)
    rows = []

    parse_options = { headers: true, header_converters: :symbol }

    CSV.open(file_name, parse_options).each do |line|
      row = CSVRow.new(line.to_h)
      rows << row
    end

    rows
  end
end
