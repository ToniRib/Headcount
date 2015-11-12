module DataCalculatable
  def average
    denom = count_non_na
    denom != 0 ? total / denom : 'N/A'
  end

  def average2(num,denom)
    denom != 0 ? num / denom : 'N/A'
  end

  def total
    data.reduce(0) { |acc, pair| acc + pair[1].to_f }
  end

  def total2(hash)
    hash.reduce(0) { |acc, pair| acc + pair[1].to_f }
  end

  def count_non_na2(hash)
    hash.values.count { |val| val != 'N/A' }
  end

  def count_non_na
    data.values.count { |val| val != 'N/A' }
  end
end
