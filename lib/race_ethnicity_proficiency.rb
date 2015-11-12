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

  # method for getting one year
  # { 2007 => { asian: 0.2847, black: 0.8473, pacific_islander: 0.9887,
                    #  hispanic: 0.145, native_american: 0.4763,
                    #  two_or_more: 0.473, white: 0.3445 } }

  # method for getting one race for all years (may need transpose)
  #  { 2007 => 0.284, 2008 => 0.473, 2009 => 0.482 }

  # method for getting just one percentage for a year & race
  # 0.345

end
