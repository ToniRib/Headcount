require_relative 'data_formattable'
require_relative 'data_calculatable'

class HighschoolGraduation
  attr_reader :name, :data

  include DataFormattable
  include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def graduation_rate_in_year(year)
    truncate_value(data[year])
  end

  def graduation_rate_by_year
    data.to_h.each do |year, value|
      data[year] = truncate_value(value)
    end
  end
end
