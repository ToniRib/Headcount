require 'free_lunch'
require 'minitest'

class FreeLunchTest < Minitest::Test
  def test_children_in_poverty_class_exists
    assert FreeLunch
  end

  def test_can_be_initialized_with_data_and_a_name
    data = { 2000 =>
             { :reduced => { :percent => 0.07, :number => 50698.0 },
               :free_or_reduced => { :percent => 0.27, :number => 195149.0 },
               :free => { :percent => 0.2, :number => 144451.0 } },
             2001 =>
             { :reduced => { :number => 51998.0, :percent => 0.07006 },
               :free_or_reduced => { :number => 204299.0, :percent => 0.27528 },
               :free => { :number => 152301.0, :percent => 0.20522 } },
             2002 =>
             { :free => { :percent => 0.2196, :number => 165107.0 },
               :free_or_reduced => { :percent => 0.28509, :number => 214349.0 },
               :reduced => { :percent => 0.06549, :number => 49242.0 } }
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

  def test_can_get_a_percentage_for_a_specific_year
    data = { 2007 =>
             { :reduced => { :number => 50698.0 },
               :free_or_reduced => { :percent => 0.2437, :number => 195149.0 },
               :free => { :percent => 0.2, :number => 144451.0 } },
             2008 =>
             { :reduced => { :number => 51998.0, :percent => 0.07006 },
               :free_or_reduced => { :number => 204299.0, :percent => 'N/A' },
               :free => { :number => 152301.0, :percent => 0.20522 } },
             2009 =>
             { :free => { :percent => 0.2196, :number => 'N/A' },
               :free_or_reduced => { :percent => 0.28509, :number => 214349.0 },
               :reduced => { :percent => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_equal 0.243, f.free_or_reduced_price_lunch_percentage_in_year(2007)
    assert_equal 'N/A', f.free_or_reduced_price_lunch_percentage_in_year(2008)
    assert_equal 0.285, f.free_or_reduced_price_lunch_percentage_in_year(2009)
  end

  def test_raises_unknown_data_error_if_year_does_not_exist
    data = { 2007 =>
             { :reduced => { :number => 50698.0 },
               :free_or_reduced => { :percent => 0.27, :number => 195149.0 },
               :free => { :percent => 0.2, :number => 144451.0 } },
             2008 =>
             { :reduced => { :number => 51998.0, :percent => 0.07006 },
               :free_or_reduced => { :number => 204299.0, :percent => 'N/A' },
               :free => { :number => 152301.0, :percent => 0.20522 } },
             2009 =>
             { :free => { :percent => 0.2196, :number => 'N/A' },
               :free_or_reduced => { :percent => 0.28509, :number => 214349.0 },
               :reduced => { :percent => 0.06549} }
    }

    f = FreeLunch.new(name: 'ACADEMY 20', data: data )

    assert_raises(UnknownDataError) do
      f.free_or_reduced_price_lunch_percentage_in_year(2015)
    end
  end
end
