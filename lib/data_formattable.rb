module DataFormattable
  def float?(str)
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

  def hash_leaves_go_empty_hashes(hash)
    empty_leaves = Hash.new({})
    empty_leaves.merge(hash)
  end
end
