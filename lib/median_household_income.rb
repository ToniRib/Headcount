require_relative 'data_formattable'
require_relative 'data_calculatable'
require_relative 'unknown_data_error'
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
    fail UnknownDataError unless check_year(year)

    vals = data.reject { |key, val| !year_in_range(key, year) || na?(val) }

    check_insufficient_info(vals)

    vals.values.reduce(:+) / vals.length
  end

  def year_in_range(arr, year)
    year >= arr[0] && year <= arr[1]
  end

  def check_year(year)
    data.keys.any? { |range| year_in_range(range, year) }
  end

  def median_household_income_average
    num = data.values.reject { |val| na?(val) }

    check_insufficient_info(num)

    num.reduce(:+).to_f / num.length
  end

  def check_insufficient_info(arr)
    fail InsufficientInformationError if arr.length == 0
  end
end
