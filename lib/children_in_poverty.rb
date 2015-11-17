require_relative 'data_formattable'
require_relative 'unknown_data_error'
require 'pry'

class ChildrenInPoverty
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def children_in_poverty_in_year(year)
    fail UnknownDataError unless year_and_percent_exist(year)

    percent = data[year][:>].fetch(:percent)

    truncate_value(percent)
  end

  def year_and_percent_exist(year)
    data.keys.include?(year) && !data[year][:>][:percent].nil?
  end
end
