


# An Enrollment instance holds the enrollment data for a single district. We create an instance like this:
#
# e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
# An instance of this class offers the following methods:

class Enrollment

  def initialize(data_hash)
    @data = data_hash
  end

  def name
    @data[:name]
  end

  def kindergarten_participation
    @data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |year, value|
      kindergarten_participation[year] = truncate_value(value)
    end
  end

  def truncate_value(value)
    is_na?(value) ? value : truncate_to_three_decimals(value)
  end

  def truncate_to_three_decimals(value)
    (value * 1000).floor / 1000.0
  end

  def is_na?(value)
    value == 'N/A'
  end

  def add_data(data_hash)
    @data.merge(data_hash) if name == data_hash[:name]
  end

end
