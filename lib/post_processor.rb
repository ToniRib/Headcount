require_relative 'data_formattable'

class PostProcessor

  include DataFormattable

  def final_data_prep(options)
    transpose_data(get_data(options))
  end

  def transpose_data(data)
    data_transpose = Hash.new{ |h, k| h[k] = {} }

    data.each_pair do |type, district|
      district.to_h.each_pair{ |name, d| data_transpose[name][type] = d }
    end

    data_transpose
  end

  def get_data(options)
    options = hash_leaves_go_empty_hashes(options)
    { :kindergarten_participation => get_year_percent_data(options[:enrollment][:kindergarten]),
      :high_school_graduation => get_year_percent_data(options[:enrollment][:high_school_graduation]),
      :third_grade => get_year_mrw_percent_data(options[:statewide_testing][:third_grade]),
      :eighth_grade => get_year_mrw_percent_data(options[:statewide_testing][:eighth_grade]),
      :math => get_year_race_percent_data(options[:statewide_testing][:math]),
      :reading => get_year_race_percent_data(options[:statewide_testing][:reading]),
      :writing => get_year_race_percent_data(options[:statewide_testing][:writing])
    }
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
