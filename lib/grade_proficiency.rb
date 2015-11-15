require_relative 'data_formattable'
require_relative 'unknown_data_error'
require 'pry'

class GradeProficiency
  attr_reader :name, :data

  include DataFormattable

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

  def proficiency_by_subject
    transpose_data(data)
  end

  def average_percentage_growth(arr)
    arr.reject! { |val| na?(val) }
    arr.each_cons(2).map { |a, b| b - a }.reduce(:+) / (arr.length - 1.0)
  end

  def average_percentage_growth_by_subject(subj)
    percent = average_percentage_growth(proficiency_for_subject(subj).values)
    truncate_value(percent)
  end

  def proficiency_for_subject(subj)
    raise UnknownDataError unless proficiency_by_subject.key?(subj)
    proficiency_by_subject[subj]
  end
end
