require_relative 'data_formattable'

class CSVRow
  attr_accessor :row_data, :headers
  include DataFormattable

  def initialize(options = {})
    @row_data = options
    @headers = options.keys
  end
end
