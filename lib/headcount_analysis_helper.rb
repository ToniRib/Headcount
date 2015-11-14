require_relative 'data_formattable'
require_relative 'data_calculatable'
class HeadcountAnalystHelper

  include DataFormattable
  include DataCalculatable

  def calculate_ratio(data1, data2)
    return 'N/A' if na?(data1) || na?(data2)

    truncate_value(data1.to_f / data2)
  end

  def in_correlation_range?(value)
    (0.6..1.5).cover?(value)
  end

  def growth_value_over_range(year_hash)
    if year_hash.length <= 1
      not_enough_data
    else
      last_year, first_year = year_hash.keys[-1], year_hash.keys[0]
      num = year_hash[last_year] - year_hash[first_year]
      denom = year_hash.length
      truncate_value(num.to_f/denom)
    end
  end

  def return_largest_growth_value(growth_values,number = 1)
    growth_values.sort!{|a,b| b <=> a}
    values = growth_values[0..(number-1)].map{|x| x.reverse}
    values.flatten! if values.length == 1
    values = [[:error,"No districts have sufficient data!"]] if values.length == 0
    values
  end

  def remove_all_entries_with_insufficient_data(data_district_array)
    data_district_array.reject{|data,district| data == not_enough_data}
  end


  def not_enough_data
    -1000
  end


  def detect_correct_inputs_for_year_growth_query(options)
    if options[:grade].nil? || options[:subject].nil?
      raise InsufficientInformationError, 'A grade and subject must be provided'
    end
  end

  def top_statewide_test_year_over_year_growth(options)   #(grade: 3, top:3, subject: math)
    detect_correct_inputs_for_year_growth_query(options)
    growth_values = district_names.map do |district|
      test_data = find_statewide_testing_by_name(district)
      test_hash = transpose_data(test_data.proficient_by_grade(options[:grade]))
      year_hash = test_hash[options[:subject]].reject{|year,value| value == "N/A"}
      response = growth_value_over_range(year_hash)
      [response,district]
    end
    growth_values = remove_all_entries_with_insufficient_data(growth_values.to_a)
    return_largest_growth_value(growth_values,options.fetch(:top,1))
  end


end
