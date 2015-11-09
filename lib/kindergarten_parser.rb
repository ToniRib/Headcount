require 'csv'
require 'pry'

class KindergartenParser

  def parse(file_name)

    data = {}

    CSV.open(file_name, headers: true, header_converters: :symbol).each do |line|
      # binding.pry
      year = line[:timeframe].to_i

      data[line[:location]] ||= {}
      data[line[:location]][year] = line[:data].to_f

    end

    data

  end

end
