require_relative 'data_formattable'
require_relative 'unknown_data_error'
require 'pry'

class FreeLunch
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    fail UnknownDataError unless year_and_percentage_exist(year)

    truncate_value(data[year][:free_or_reduced][:percent])
  end

  def year_and_percentage_exist(year)
    data[year] && data[year][:free_or_reduced][:percent]
  end
end
