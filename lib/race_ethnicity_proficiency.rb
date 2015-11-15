require_relative 'data_formattable'
require_relative 'unknown_data_error'
require 'pry'

class RaceEthnicityProficiency
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def proficiency_in_year(year)
    data[year].to_h.map { |race, percent| [race, truncate_value(percent)] }.to_h
  end

  def proficiency_by_race_or_ethnicity(race)
    race_data = transpose_data(data)[race].to_h

    if race_data.empty?
      fail UnknownRaceError, "Unknown race/ethnicity requested: #{race}."
    end

    race_data.map { |year, percent| [year, truncate_value(percent)] }.to_h
  end

  def proficiency_by_race_in_year(race, year)
    year_data = proficiency_in_year(year)

    if year_or_race_does_not_exist(year_data, race)
      fail UnknownDataError, 'Data does not exist in dataset'
    end

    year_data[race]
  end

  def year_or_race_does_not_exist(year_data, race)
    year_data.empty? || year_data[race].nil?
  end
end
