require_relative 'median_household_income'
require_relative 'children_in_poverty'
require_relative 'free_lunch'
require_relative 'title_i'

class EconomicProfile
  attr_reader :name, :median, :lunch, :children, :title, :data_hash

  def initialize(data_hash)
    @data_hash = data_hash
    @name = data_hash[:name]
    @median = MedianHouseholdIncome.new(opt(:median_household_income))
    @lunch = FreeLunch.new(opt(:lunch))
    @children = ChildrenInPoverty.new(opt(:children_in_poverty))
    @title = TitleI.new(opt(:title_i))
  end

  def opt(file_key)
    {name: name, data: data_hash[file_key]}
  end

  def median_household_income_average
    median.median_household_income_average
  end

  def estimated_median_household_income_in_year(year)
    median.estimated_median_household_income_in_year(year)
  end

  def children_in_poverty_in_year(year)
    children.children_in_poverty_in_year(year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    lunch.free_or_reduced_price_lunch_percentage_in_year(year)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    lunch.free_or_reduced_price_lunch_number_in_year(year)
  end

  def title_i_in_year(year)
    title.title_i_in_year(year)
  end
end
