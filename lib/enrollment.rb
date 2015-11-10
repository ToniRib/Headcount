require_relative 'data_formattable'

class Enrollment
  include DataFormattable

  def initialize(data_hash)
    @data = data_hash
  end

  def name
    @data[:name]
  end

  def kindergarten_participation
    @data[:kindergarten_participation]
  end

  def high_school_graduation
    @data[:high_school_graduation]
  end

  def average(category)
    denom = count_non_na(category)
    denom != 0 ? total(category)/denom : nil
  end

  def total(category)
    @data[category].reduce(0) { |acc,pair| acc + pair[1].to_f }
  end

  def count_non_na(category)
    @data[category].values.reject { |val| val == "N/A" }.length
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |year, value|
      kindergarten_participation[year] = truncate_value(value)
    end
  end

  def add_data(data_hash)
    @data.merge(data_hash) if name == data_hash[:name]
  end

  def kindergarten_participation_in_year(year)
    truncate_value(kindergarten_participation[year]) if year_exists?(year)
  end

  def year_exists?(year)
    kindergarten_participation[year]
  end
end
