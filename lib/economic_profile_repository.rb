require_relative 'economic_profile'
require_relative 'post_processor'

class EconomicProfileRepository
  attr_reader :profiles

  def initialize
    @profiles = {}
  end

  def load_data(options)
    post = PostProcessor.new
    data = post.get_economic_profile_data(options)

    data.each_pair do |district_name, district_data|
      profile_options = { name: district_name.upcase }.merge(district_data)
      profiles[district_name.upcase] = EconomicProfile.new(profile_options)
    end
  end

  def find_by_name(district_name)
    profiles[district_name.upcase] if district_exists?(district_name)
  end

  def district_exists?(district_name)
    profiles.keys.include?(district_name.upcase)
  end
end
