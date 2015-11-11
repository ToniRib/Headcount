require_relative 'data_formattable'

class Enrollment
  attr_reader :kp, :hs

  include DataFormattable

  def initialize(data_hash)
    @data = data_hash
    name = data_hash[:name]
    @kp = KindergartenParticipation.new(name: name, data: data_hash[:kindergarten_participation])
    @hs = HighschoolGraduation.new(name: name, data: data_hash[:high_school_graduation])
  end

  def name
    @data[:name]
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
    kp.participation_by_year
  end

  def kindergarten_participation_in_year(year)
    kp.participation_in_year(year)
  end

  def graduation_rate_by_year
    hs.graduation_rate_by_year
  end

  def graduation_rate_in_year(year)
    hs.graduation_rate_in_year(year)
  end
end
