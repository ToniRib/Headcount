require_relative 'kindergarten_parser'

class DistrictRepository

  def load_data(parser_to_file)
    data = KindergartenParser.new.parse(parser_to_file[:kindergarten])
  end
  
end


if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
  district = dr.find_by_name("ACADEMY 20")
end
