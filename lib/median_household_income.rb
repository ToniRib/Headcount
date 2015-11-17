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
end














# def estimated_median_household_income(year)
#   data.reduce([0,0]) do |m,(k,v)|
#     if year_in_range(k,year)
#       m.map! do |n,d|
#         n + v
#         d + 1
#       end
#   end
# end
#
# def year_in_range(arr,year)
#   arr[0]<= year && year <= arr[1]
# end
