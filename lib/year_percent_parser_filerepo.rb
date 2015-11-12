require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearPercentParserFileRepo
  include DataFormattable

  attr_reader :file_repo

  def initialize(file_repo = nil)
    @file_repo = file_repo
  end

  def parse(file_name)
    data = {}

    file_repo.files[file_name].each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] = row_data
    end

    data
  end
end
