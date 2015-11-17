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
    data.to_h.each { |_, values| truncate_each_subject_value(values) }
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
      fail UnknownDataError, 'Data does not exist in dataset'
    end

    year_data[subj]
  end

  def year_or_subject_does_not_exist(year_data, subj)
    year_data.empty? || year_data[subj].nil?
  end

  def proficiency_by_subject
    transpose_data(data)
  end

  def average_percentage_growth(data)
    data.reject! { |_, v| na?(v) }

    fail InsufficientInformationError if data.count < 2

    first_year = data.keys.min
    last_year = data.keys.max

    (data[last_year]) - data[first_year] / (last_year - first_year)
  end

  def avg_percentage_growth_by_subject(subj)
    percent = average_percentage_growth(proficiency_for_subject(subj))
    truncate_value(percent)
  end

  def avg_percentage_growth_all_subjects(weights)
    {
      math: avg_percentage_growth_by_subject(:math) * weights[:math],
      reading: avg_percentage_growth_by_subject(:reading) * weights[:reading],
      writing: avg_percentage_growth_by_subject(:writing) * weights[:writing]
    }
  end

  def combined_average_growth(weights)
    total = avg_percentage_growth_all_subjects(weights).values.reduce(:+)
    total.zero? ? 0 : truncate_value(total)
  end

  def proficiency_for_subject(subj)
    fail UnknownDataError unless proficiency_by_subject.key?(subj)

    proficiency_by_subject[subj]
  end
end
