require_relative 'data_formattable'
require_relative 'unknown_data_error'

class TitleI
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def title_i_in_year(year)
    fail UnknownDataError unless data[year]

    truncate_value(data[year])
  end
end
