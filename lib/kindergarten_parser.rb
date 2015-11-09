require 'csv'
require 'pry'

class KindergartenParser

  def parse(file_name)

    data = {}

    CSV.open(file_name, headers: true, header_converters: :symbol).each do |line|

      data[line[:location]] = {}

    end

    data

  end

end
