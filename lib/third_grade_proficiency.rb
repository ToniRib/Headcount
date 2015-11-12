require_relative 'data_formattable'

class ThirdGradeProficiency
  attr_reader :name, :data

  include DataFormattable
  # include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def proficiency
    data.to_h.each do |year, values|
      truncate_each_subject_value(values)
    end
  end

  def truncate_each_subject_value(values)
    values.each do |subject, percent|
      values[subject] = truncate_value(percent)
    end
  end
end
