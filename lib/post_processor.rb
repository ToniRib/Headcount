require_relative 'data_formattable'
require_relative 'year_percent_parser'
require_relative 'year_mrw_percent_parser'
require_relative 'year_race_percent_parser'

class PostProcessor
  include DataFormattable

  def get_enrollment_data(options)
    data = {
      kindergarten_participation: get_year_percent_data(kdata(options)),
      high_school_graduation: get_year_percent_data(hsdata(options))
    }

    transpose_data(data)
  end

  def get_statewide_testing_data(options)
    options = hash_leaves_go_empty_hashes(options)

    data = {
      third_grade_proficiency: get_year_mrw_percent_data(third_data(options)),
      eighth_grade_proficiency: get_year_mrw_percent_data(eighth_data(options)),
      math: get_year_race_percent_data(math_data(options)),
      reading: get_year_race_percent_data(reading_data(options)),
      writing: get_year_race_percent_data(writing_data(options))
    }

    transpose_data(data)
  end

  def kdata(options)
    options[:enrollment][:kindergarten]
  end

  def hsdata(options)
    options[:enrollment][:high_school_graduation]
  end

  def third_data(options)
    options[:statewide_testing][:third_grade]
  end

  def eighth_data(options)
    options[:statewide_testing][:eighth_grade]
  end

  def math_data(options)
    options[:statewide_testing][:math]
  end

  def reading_data(options)
    options[:statewide_testing][:reading]
  end

  def writing_data(options)
    options[:statewide_testing][:writing]
  end

  def get_year_percent_data(file)
    return nil if file.nil?
    pre = Preprocessor.new
    ruby_rows = pre.pull_from_CSV(file)
    YearPercentParser.new.parse(ruby_rows)
  end

  def get_year_mrw_percent_data(file)
    return nil if file.nil?
    pre = Preprocessor.new
    ruby_rows = pre.pull_from_CSV(file)
    YearMRWPercentParser.new.parse(ruby_rows)
  end

  def get_year_race_percent_data(file)
    return nil if file.nil?
    pre = Preprocessor.new
    ruby_rows = pre.pull_from_CSV(file)
    YearRacePercentParser.new.parse(ruby_rows)
  end
end
