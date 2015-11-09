require 'csv'
require 'pry'

class KindergartenParser

  def parse(file_name)

    data = {}

    CSV.open(file_name, headers: true, header_converters: :symbol).each do |line|
      # binding.pry

      data[line[:location]] ||= {}
      data[line[:location]][line[:timeframe]] = line[:data]

    end

    data

  end

end
