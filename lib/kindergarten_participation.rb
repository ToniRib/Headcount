require_relative 'data_formattable'

class KindergartenParticipation
  attr_reader :name, :data

  include DataFormattable

  def initialize(options)
    @name = options[:name]
    @data = options[:data]
  end

  def participation_in_year(year)
    truncate_value(data[year])
  end

  def participation_by_year
    data.to_h.each do |year, value|
      data[year] = truncate_value(value)
    end
  end

  def average
    denom = count_non_na
    denom != 0 ? total / denom : 'N/A'
  end

  def total
    data.reduce(0) { |acc, pair| acc + pair[1].to_f }
  end

  def count_non_na
    data.values.count { |val| val != 'N/A' }
  end
end
