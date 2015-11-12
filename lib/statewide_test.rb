require_relative 'grade_proficiency'
require_relative 'race_ethnicity_proficiency'

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

  def raise_unknown_data_error
    raise UnknownDataError, 'Unknown grade requested'
  end
end
