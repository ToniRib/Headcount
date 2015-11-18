require_relative 'data_formattable'
require_relative 'unknown_data_error'

class ChildrenInPoverty
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def children_in_poverty_in_year(year)
    fail UnknownDataError unless data[year]

    truncate_value(data[year])
  end
end
