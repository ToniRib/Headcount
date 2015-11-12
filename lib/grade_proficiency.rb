require_relative 'data_formattable'
require_relative 'unknown_data_error'
require 'pry'

class GradeProficiency
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
    # discuss with aaron: should project change this and others like it
    # since it is directly modifying data (see map below)
    values.each { |subj, percent| values[subj] = truncate_value(percent) }
  end

  def proficiency_in_year(year)
    data[year].to_h.map { |subj, percent| [subj, truncate_value(percent)] }.to_h
  end

  def proficiency_in_year_and_subject(year, subj)
    year_data = proficiency_in_year(year)

    if year_or_subject_does_not_exist(year_data, subj)
      raise UnknownDataError, 'Data does not exist in dataset'
    end

    year_data[subj]
  end

  def year_or_subject_does_not_exist(year_data, subj)
    year_data.empty? || year_data[subj].nil?
  end
end
