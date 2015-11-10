module DataFormattable


  def float?(str)
    str.chars[0].to_i.to_s == str.chars[0]
  end

  def convert_to_float(str)
    float?(str) ? str.to_f : 'N/A'
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

end
