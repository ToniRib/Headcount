module DataCalculatable
  def average
    denom = count_non_na
    denom != 0 ? total / denom : 'N/A'
  end

  def total
    data.reduce(0) { |a, e| a + e[1].to_f }
  end

  def count_non_na
    data.values.count { |val| val != 'N/A' }
  end

  def calculate_ratio(data1, data2)
    return 'N/A' if na?(data1) || na?(data2)

    truncate_value(data1.to_f / data2)
  end
end
