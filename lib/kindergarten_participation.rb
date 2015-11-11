class KindergartenParticipation
  attr_reader :name, :data

  def initialize(options)
    @name = options[:name]
    @data = options[:data]
  end
end
