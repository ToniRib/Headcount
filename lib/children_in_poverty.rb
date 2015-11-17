require_relative 'data_formattable'
require_relative 'data_calculatable'

class ChildrenInPoverty
  attr_reader :name, :data

  include DataFormattable
  include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def children_in_poverty_in_year(year)

  end

end
