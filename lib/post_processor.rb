require_relative 'data_formattable'
require_relative 'year_percent_parser'
require_relative 'year_mrw_percent_parser'
require_relative 'year_race_percent_parser'

class PostProcessor

  include DataFormattable

  def get_enrollment_data(options)
    data = { :kindergarten_participation => get_year_percent_data(options[:enrollment][:kindergarten]),
      :high_school_graduation => get_year_percent_data(options[:enrollment][:high_school_graduation])
    }
    transpose_data(data)
  end

  def get_statewide_testing_data(options)
    options = hash_leaves_go_empty_hashes(options)
    data = {
      :third_grade_proficiency => get_year_mrw_percent_data(options[:statewide_testing][:third_grade]),
      :eighth_grade_proficiency => get_year_mrw_percent_data(options[:statewide_testing][:eighth_grade]),
      :math => get_year_race_percent_data(options[:statewide_testing][:math]),
      :reading => get_year_race_percent_data(options[:statewide_testing][:reading]),
      :writing => get_year_race_percent_data(options[:statewide_testing][:writing])}
    transpose_data(data)
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
