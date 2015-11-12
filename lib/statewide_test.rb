require_relative 'grade_proficiency'

class StatewideTest
  attr_reader :name, :third, :eighth

  # include DataFormattable

  def initialize(data_hash)
    @name = data_hash[:name]
    @third = GradeProficiency.new(third_options(data_hash))
    @eighth = GradeProficiency.new(eighth_options(data_hash))
  end

  def third_options(data)
    { name: name, data: data[:third_grade_proficiency] }
  end

  def eighth_options(data)
    { name: name, data: data[:eighth_grade_proficiency] }
  end

  def proficient_by_grade(grade)
    case grade
    when 3 then third.proficiency_by_year
    when 8 then eighth.proficiency_by_year
    else        raise UnknownDataError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    case grade
    when 3 then third.proficiency_in_year_and_subject(year, subject)
    when 8 then eighth.proficiency_in_year_and_subject(year, subject)
    else        raise UnknownDataError
    end
  end
end
