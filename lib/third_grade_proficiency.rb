require_relative 'data_formattable'
require 'pry'

class ThirdGradeProficiency
  attr_reader :name, :data

  include DataFormattable
  # include DataCalculatable

  def initialize(options)
    @name = options[:name]
    @data = options[:data] || @data = {}
  end

  def proficiency_by_year
    data.to_h.each { |year, values| truncate_each_subject_value(values) }
  end

  def truncate_each_subject_value(values)
    values.each { |subject, percent| values[subject] = truncate_value(percent) }
  end

  def proficiency_in_year(year)
    data[year].map do |subject, percent|
      [subject, truncate_value(percent)]
    end.to_h
  end
end
