require_relative 'median_household_income'
require_relative 'children_in_poverty'
require_relative 'free_lunch'
require_relative 'title_i'



class EconomicProfile
  attr_reader :name, :median, :lunch, :children, :title, :data_hash

  def initialize(data_hash)
    @data_hash = data_hash
    @name = data_hash[:name]
    @median = MedianHouseholdIncome.new(name: name, data: data_hash[:median_household_income])
    @lunch = FreeLunch.new(opt(:lunch))
    @children = ChildrenInPoverty.new(opt(:children_in_poverty))
    @title = TitleI.new(opt(:title_i))
  end

  def median_household_income_average

  end

  def opt(file_key)
    {name: name, data: data_hash[file_key]}
  end


end
