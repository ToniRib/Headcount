require_relative 'data_formattable'
require_relative 'data_calculatable'

class TitleI
  attr_reader :name, :data

  include DataFormattable
  include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def income_in_year_range(start_year)
    truncate_value(data[year])
  end

  def participation_by_year
    data.to_h.each do |year, value|
      data[year] = truncate_value(value)
    end
  end
end
