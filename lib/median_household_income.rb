require_relative 'data_formattable'
require_relative 'data_calculatable'
require 'pry'

class MedianHouseholdIncome
  attr_reader :name, :data

  include DataFormattable
  include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def estimated_median_household_income_in_year(year)
    vals = data.reject { |key,val| !year_in_range(key,year) }

    vals.values.reduce(:+) / vals.length
  end

  def year_in_range(arr, year)
    year >= arr[0] && year <= arr[1]
  end
end
