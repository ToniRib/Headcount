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

  def kindergarten_participation_in_year(year)
    truncate_value(kindergarten_participation[year]) if year_exists?(year)
  end

  def year_exists?(year)
    kindergarten_participation[year]
  end

end
