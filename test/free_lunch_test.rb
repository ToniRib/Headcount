require 'free_lunch'
require 'minitest'

class FreeLunchTest < Minitest::Test
  def test_children_in_poverty_class_exists
    assert FreeLunch
  end

  # this needs to be fixed

  def test_can_be_initialized_with_data_and_a_name
    data = { 2000 =>
             { :reduced => { :percentage => 0.07, :total => 50698.0 },
               :free_or_reduced => { :percentage => 0.27, :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2001 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 0.27528 },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2002 =>
             { :free => { :percentage => 0.2196, :total => 165107.0 },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549, :total => 49242.0 } }
      }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 'ACADEMY 20', f.name
    assert_equal data, f.data
  end

  def test_can_be_initialized_with_name_only_and_nil_data
    f = FreeLunch.new(name: 'ACADEMY 20', data: nil )

    expected = {}

    assert_equal 'ACADEMY 20', f.name
    assert_equal expected, f.data
  end

  def test_can_get_a_percentage_of_free_or_reduced_lunch_for_a_specific_year
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :percentage => 0.2437, :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.243, f.free_or_reduced_price_lunch_percentage_in_year(2007)
    assert_equal 'N/A', f.free_or_reduced_price_lunch_percentage_in_year(2008)
    assert_equal 0.285, f.free_or_reduced_price_lunch_percentage_in_year(2009)
  end

  def test_percentage_in_year_raises_unknown_data_error_if_year_does_not_exist
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :percentage => 0.27, :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_percentage_in_year(2015)
    end
  end

  def test_percentage_in_year_raises_unknown_data_error_if_percent_does_not_exist
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_percentage_in_year(2007)
    end
  end

  def test_can_get_a_number_of_free_or_reduced_lunch_for_specific_year
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :percentage => 0.2437, :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 195149.0, f.free_or_reduced_price_lunch_number_in_year(2007)
    assert_equal 204299.0, f.free_or_reduced_price_lunch_number_in_year(2008)
    assert_equal 214349.0, f.free_or_reduced_price_lunch_number_in_year(2009)
  end

  def test_number_in_year_raises_unknown_data_error_if_year_does_not_exist
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :percentage => 0.27, :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509, :total => 214349.0 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_number_in_year(2015)
    end
  end

  def test_number_in_year_raises_unknown_data_error_if_number_does_not_exist
    data = { 2007 =>
             { :reduced => { :total => 50698.0 },
               :free_or_reduced => { :total => 195149.0 },
               :free => { :percentage => 0.2, :total => 144451.0 } },
             2008 =>
             { :reduced => { :total => 51998.0, :percentage => 0.07006 },
               :free_or_reduced => { :total => 204299.0, :percentage => 'N/A' },
               :free => { :total => 152301.0, :percentage => 0.20522 } },
             2009 =>
             { :free => { :percentage => 0.2196, :total => 'N/A' },
               :free_or_reduced => { :percentage => 0.28509 },
               :reduced => { :percentage => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_number_in_year(2009)
    end
  end
end
