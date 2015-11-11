require_relative 'data_formattable'
require_relative 'highschool_graduation'
require_relative 'kindergarten_participation'

class Enrollment
  attr_reader :name, :kp, :hs

  include DataFormattable

  def initialize(data_hash)
    @name = data_hash[:name]
    @kp = KindergartenParticipation.new(kp_options(data_hash))
    @hs = HighschoolGraduation.new(hs_options(data_hash))
  end

  def kp_options(data)
    { name: name, data: data[:kindergarten_participation] }
  end

  def hs_options(data)
    { name: name, data: data[:high_school_graduation] }
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
