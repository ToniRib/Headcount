require 'csv'
require 'pry'

class KindergartenParser
  def parse(file_name)
    data = {}

    CSV.open(file_name, headers: true, header_converters: :symbol).each do |line|
      year = line[:timeframe].to_i
      data[line[:location]] ||= {}
      data[line[:location]][year] = convert_to_float(line[:data])
    end
    data
  end

  def float?(str)
    str.chars[0].to_i.to_s == str.chars[0]
  end

  def convert_to_float(str)
    float?(str) ? str.to_f : 'N/A'
  end
end
