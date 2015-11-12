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
      raise UnknownRaceError, 'Unknown race/ethnicity requested'
    end

    race_data.map { |year, percent| [year, truncate_value(percent)] }.to_h
  end

  # method for getting one race for all years (may need transpose)
  #  { 2007 => 0.284, 2008 => 0.473, 2009 => 0.482 }

  # method for getting just one percentage for a year & race
  # 0.345

  # will move into DataFormattable module
  def transpose_data(data)
    data_transpose = Hash.new{ |h, k| h[k] = {} }

    data.each_pair do |type, district|
      district.to_h.each_pair{ |name, d| data_transpose[name][type] = d }
    end

    data_transpose
  end
end
