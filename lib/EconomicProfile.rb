require_relative 'median_household_income'

class EconomicProfile
  attr_reader :name, :mhi

  def initialize(data_hash)
    @name = data_hash[:name]
  end
end
