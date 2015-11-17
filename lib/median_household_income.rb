require_relative 'data_formattable'
require_relative 'data_calculatable'

class MedianHouseholdIncome
  attr_reader :name, :data

  include DataFormattable
  include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def estimated_median_household_income_in_year(year)

  end
end
