require_relative 'data_formattable'
require_relative 'data_calculatable'
class HeadcountAnalystHelper

  include DataFormattable
  include DataCalculatable

  attr_reader :district_names

  def initialize(district_names = nil)
    @district_names = district_names
  end

  def calculate_ratio(data1, data2)
    return 'N/A' if na?(data1) || na?(data2)

    truncate_value(data1.to_f / data2)
  end

  def in_correlation_range?(value)
    (0.6..1.5).cover?(value)
  end

  def find_statewide_testing_by_name(district_name)
    @district_repository.find_by_name(district_name).statewide_test
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

  def sort_growth_values(growth_values)
    growth_values.sort!{|a,b| b[1] <=> a[1]}
    growth_values = [:error,"No districts have sufficient data!"] if growth_values.length == 0
    growth_values
  end

  def remove_all_entries_with_insufficient_data(data_district_hash)
    data_district_hash.reject{|district,data| data <= not_enough_data/2}
  end

  def not_enough_data
    -1000
  end

  def detect_correct_inputs_for_year_growth_query(options)
    if options[:grade].nil?
      raise InsufficientInformationError, 'A grade and subject must be provided'
    end
  end

end
