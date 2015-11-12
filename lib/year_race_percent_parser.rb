require 'csv'
require 'pry'
require_relative 'data_formattable'

class YearRacePercentParser
  include DataFormattable

  def parse(ruby_rows)
    data = {}
    ruby_rows.each do |csv_row|
      year = csv_row.row_data[:timeframe].to_i
      race = race_to_sym[csv_row.row_data[:race_ethnicity]]
      row_data = convert_to_float(csv_row.row_data[:data])

      data[csv_row.row_data[:location]] ||= {}
      data[csv_row.row_data[:location]][year] ||= {}
      data[csv_row.row_data[:location]][year][race] = row_data
    end

    data
  end

  def race_to_sym
    symbols = [:all, :asian, :black, :pacific_islander,
               :hispanic, :native_american, :two_or_more, :white]
    strings = ["All Students","Asian","Black","Hawaiian/Pacific Islander",
               "Hispanic","Native American","Two or more","White"]
    strings.zip(symbols).to_h
  end
end

# ACADEMY 20,All Students,2011,Percent,0.68
# ACADEMY 20,Asian,2011,Percent,0.8169
# ACADEMY 20,Black,2011,Percent,0.4246
# ACADEMY 20,Hawaiian/Pacific Islander,2011,Percent,0.5686
# ACADEMY 20,Hispanic,2011,Percent,0.5681
# ACADEMY 20,Native American,2011,Percent,0.6143
# ACADEMY 20,Two or more,2011,Percent,0.6772
# ACADEMY 20,White,2011,Percent,0.7065
