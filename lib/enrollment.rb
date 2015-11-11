require_relative 'data_formattable'
require_relative 'highschool_graduation'
require_relative 'kindergarten_participation'

class Enrollment
  attr_reader :name, :kp, :hs

  include DataFormattable

  def initialize(data_hash)
    @name = data_hash[:name]
    @kp = KindergartenParticipation.new(name: name, data: data_hash[:kindergarten_participation])
    @hs = HighschoolGraduation.new(name: name, data: data_hash[:high_school_graduation])
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
