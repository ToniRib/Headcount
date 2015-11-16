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

  def get_enrollment_data(opt)
    e = :enrollment
    data = {
      kindergarten_participation: get_data(:percent,opt[e][:kindergarten]),
      high_school_graduation: get_data(:percent,opt[e][:high_school_graduation])
    }
    transpose_data(data)
  end

  def get_statewide_testing_data(opt)
    sw = :statewide_testing
    opt = nil_key_return_empty_hash(opt)
    data = {
      third_grade_proficiency: get_data(:mrw,opt[sw][:third_grade]),
      eighth_grade_proficiency: get_data(:mrw,opt[sw][:eighth_grade]),
      math: get_data(:race,opt[sw][:math]),
      reading: get_data(:race,opt[sw][:reading]),
      writing: get_data(:race,opt[sw][:writing])
    }
    transpose_data(data)
  end

  def get_data(key, file)
    ruby_rows = prep_ruby_rows(file)
    eval("#{key}.parse(ruby_rows) if ruby_rows")
  end

  def prep_ruby_rows(file)
    pre.pull_from_csv(file) if file
  end
end
