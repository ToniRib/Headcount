require_relative 'data_formattable'
require_relative 'year_percent_parser'
require_relative 'year_mrw_percent_parser'
require_relative 'year_race_percent_parser'

class PostProcessor
  include DataFormattable

  attr_reader :pre, :percent, :mrw, :race

  def initialize
    @pre = Preprocessor.new
    @percent = YearPercentParser.new
    @mrw = YearMRWPercentParser.new
    @race = YearRacePercentParser.new
  end

  def get_enrollment_data(options)
    data = {
      kindergarten_participation: get_data(:percent,kdata(options)),
      high_school_graduation: get_data(:percent,hsdata(options))
    }
    transpose_data(data)
  end

  def get_statewide_testing_data(options)
    options = hash_leaves_go_empty_hashes(options)
    data = {
      third_grade_proficiency: get_data(:mrw,third_data(options)),
      eighth_grade_proficiency: get_data(:mrw,eighth_data(options)),
      math: get_data(:race,math_data(options)),
      reading: get_data(:race,reading_data(options)),
      writing: get_data(:race,writing_data(options))
    }
    transpose_data(data)
  end

  def get_data(key, file)
    ruby_rows = prep_ruby_rows(file)
    eval("#{key}.parse(ruby_rows) if ruby_rows")
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

  def prep_ruby_rows(file)
    pre.pull_from_csv(file) if file
  end

  # def get_year_percent_data(file)
  #   ruby_rows = prep_ruby_rows(file)
  #   percent.parse(ruby_rows) if ruby_rows
  # end
  #
  # def get_year_mrw_percent_data(file)
  #   ruby_rows = prep_ruby_rows(file)
  #   mrw.parse(ruby_rows) if ruby_rows
  # end
  #
  # def get_year_race_percent_data(file)
  #   ruby_rows = prep_ruby_rows(file)
  #   race.parse(ruby_rows) if ruby_rows
  # end
end
