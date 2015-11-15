require_relative 'grade_proficiency'
require_relative 'race_ethnicity_proficiency'
require 'pry'

class StatewideTest
  attr_reader :name, :third, :eighth, :math, :reading, :writing

  def initialize(data_hash)
    @name = data_hash[:name]
    @third = GradeProficiency.new(third_options(data_hash))
    @eighth = GradeProficiency.new(eighth_options(data_hash))
    @math = RaceEthnicityProficiency.new(math_options(data_hash))
    @reading = RaceEthnicityProficiency.new(reading_options(data_hash))
    @writing = RaceEthnicityProficiency.new(writing_options(data_hash))
  end

  def third_options(data)
    { name: name, data: data[:third_grade_proficiency] }
  end

  def eighth_options(data)
    { name: name, data: data[:eighth_grade_proficiency] }
  end

  def math_options(data)
    { name: name, data: data[:math] }
  end

  def reading_options(data)
    { name: name, data: data[:reading] }
  end

  def writing_options(data)
    { name: name, data: data[:writing] }
  end

  def proficient_by_grade(grade)
    case grade
    when 3 then third.proficiency_by_year
    when 8 then eighth.proficiency_by_year
    else        raise_unknown_data_error
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    case grade
    when 3 then third.proficiency_in_year_and_subject(year, subject)
    when 8 then eighth.proficiency_in_year_and_subject(year, subject)
    else        raise_unknown_data_error
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    case subject
    when :math    then math.proficiency_by_race_in_year(race, year)
    when :reading then reading.proficiency_by_race_in_year(race, year)
    when :writing then writing.proficiency_by_race_in_year(race, year)
    else          raise_unknown_data_error
    end
  end

  def average_percent_growth_by_grade_all_subjects(grade)
    case grade
    when 3 then third.average_percentage_growth_all_subjects
    when 8 then eighth.average_percentage_growth_all_subjects
    else        raise_unknown_data_error
    end
  end

  def average_percent_growth_by_grade_for_subject(grade, subject)
    case grade
    when 3 then third.average_percentage_growth_by_subject(subject)
    when 8 then eighth.average_percentage_growth_by_subject(subject)
    else        raise_unknown_data_error
    end
  end

  def proficient_by_race_or_ethnicity(race)
    m = math.proficiency_by_race_or_ethnicity(race)
    r = reading.proficiency_by_race_or_ethnicity(race)
    w = writing.proficiency_by_race_or_ethnicity(race)

    years_with_data_across_subjects(m, r, w).map do |year|
      [year, { math: m[year], reading: r[year], writing: w[year] }]
    end.to_h
  end

  def years_with_data_across_subjects(math, reading, writing)
    math.keys | reading.keys | writing.keys
  end

  def raise_unknown_data_error
    raise UnknownDataError, 'Unknown grade requested'
  end
end
