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
    denom != 0 ? total(category) / denom : 'N/A'
  end

  def total(category)
    @data[category].reduce(0) { |acc, pair| acc + pair[1].to_f }
  end

  def count_non_na(category)
    @data[category].values.count { |val| val != 'N/A' }
  end

  def kindergarten_participation_by_year
    percentage_by_year(:kindergarten_participation)
  end

  def graduation_rate_by_year
    percentage_by_year(:high_school_graduation)
  end

  def percentage_by_year(type)
    @data[type].to_h.each do |year, value|
      @data[type][year] = truncate_value(value)
    end
  end
  #
  # def add_data(data_hash)
  #   @data.merge(data_hash) if name == data_hash[:name]
  # end

  def graduation_rate_in_year(year)
    if year_exists?(:high_school_graduation, year)
      truncate_value(high_school_graduation[year])
    end
  end

  def kindergarten_participation_in_year(year)
    if year_exists?(:kindergarten_participation, year)
      truncate_value(kindergarten_participation[year])
    end
  end

  def year_exists?(type, year)
    @data[type].to_h[year]
  end
end
