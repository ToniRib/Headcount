module DataFormattable
  def float?(str)
    return false if str.nil?
    
    str.chars[0].to_i.to_s == str.chars[0]
  end

  def convert_to_float(str)
    float?(str) ? str.to_f : 'N/A'
  end

  def truncate_value(value)
    if na?(value) || value.nil?
      value
    else
      truncate_to_three_decimals(value)
    end
  end

  def truncate_to_three_decimals(value)
    (value * 1000).floor / 1000.0
  end

  def na?(value)
    value == 'N/A'
  end

  def bool_to_binary
    { true => 1, false => 0 }
  end

  def nil_key_return_empty_hash(hash)
    empty_leaves = Hash.new({})
    empty_leaves.merge(hash)
  end

  def transpose_data(data)
    data_transpose = Hash.new { |h, k| h[k] = {} }

    data.each_pair do |type, district|
      district.to_h.each_pair { |name, d| data_transpose[name][type] = d }
    end

    data_transpose
  end
end
