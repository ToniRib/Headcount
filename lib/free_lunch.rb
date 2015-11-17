require_relative 'data_formattable'
require_relative 'unknown_data_error'

class FreeLunch
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    fail UnknownDataError if data[year].nil?

    truncate_value(data[year])
  end
end
