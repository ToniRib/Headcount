require 'csv'
require 'pry'
require 'data_formattable'

class KindergartenParser
  include DataFormattable

  def parse(file_name)
    data = {}
    parse_options = { headers: true, header_converters: :symbol }

    CSV.open(file_name, parse_options).each do |line|
      year = line[:timeframe].to_i
      data[line[:location]] ||= {}
      data[line[:location]][year] = convert_to_float(line[:data])
    end

    data
  end
end
