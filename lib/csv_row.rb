class CSVRow

  attr_reader :row_data, :headers

  def initialize(options = {})
    @row_data = options
    @headers = options.keys
  end
end
