require_relative 'year_percent_parser'
require_relative 'enrollment'
require_relative 'pre_processor'
require_relative 'post_processor'
require 'pry'

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

if __FILE__ == $PROGRAM_NAME
  ep = EconomicProfileRepository.new
  ep.load_data(
            {
            :economic_profile => {
              :median_household_income => "Median household income.csv",
              :children_in_poverty => "School-aged children in poverty.csv",
              :free_or_reduced_price_lunch => "Students qualifying for free or reduced price lunch.csv",
              :title_i => "Title I students.csv"
            }}
  )
  p ep.find_by_name('ACADEMY 20')
end
