require_relative 'median_household_income'

class EconomicProfile
  attr_reader :name, :median, :lunch, :children

  def initialize(data_hash)
    @name = data_hash[:name]
    @median = MedianHouseholdIncome.new(name: name, data: data_hash[:median_household_income])
  end
end
