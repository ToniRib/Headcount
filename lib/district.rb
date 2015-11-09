


class District

  attr_reader :name

  def initialize(name_hash)
    @name = name_hash[:name]
    @enrollment = nil
    @testing = nil
    @econ_profile = nil
  end


end
