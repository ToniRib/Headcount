class ThirdGradeProficiency
  attr_reader :name, :data

  # include DataFormattable
  # include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end
end
