require_relative 'district_repository'
require_relative 'data_formattable'
require_relative 'data_calculatable'

class HeadcountAnalyst
  attr_reader :district_repository, :helper

  include DataFormattable
  include DataCalculatable

  def initialize(dr = nil)
    @district_repository = dr
    @helper = HeadcountAnalystHelper.new
  end

  def find_enrollment_by_name(district_name)
    @district_repository.find_by_name(district_name).enrollment
  end

  def find_statewide_testing_by_name(district_name)
    @district_repository.find_by_name(district_name).statewide_test
  end

  def district_names
    @district_repository.districts.keys
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    k = kindergarten_participation_rate_variation(district_name,
                                                  against: 'COLORADO')
    g = highschool_graduation_rate_variation(district_name,
                                             against: 'COLORADO')

    helper.calculate_ratio(k, g)
  end

  def kindergarten_participation_rate_variation(district_name, vs)
    average1 = find_enrollment_by_name(district_name).kp.average
    average2 = find_enrollment_by_name(vs[:against]).kp.average

    helper.calculate_ratio(average1, average2)
  end

  def highschool_graduation_rate_variation(district_name, vs)
    average1 = find_enrollment_by_name(district_name).hs.average
    average2 = find_enrollment_by_name(vs[:against]).hs.average

    helper.calculate_ratio(average1, average2)
  end

  def kindergarten_participation_rate_variation_trend(district_name, vs)
    variation = {}

    kp_dist1 = find_enrollment_by_name(district_name).kp.data
    kp_dist2 = find_enrollment_by_name(vs[:against]).kp.data

    kp_dist1.each do |year, data|
      variation[year] = helper.calculate_ratio(data, kp_dist2[year])
    end

    variation
  end

  def kgp_correlates_with_hgr_district(district_name)
    x = kindergarten_participation_against_high_school_graduation(district_name)
    helper.in_correlation_range?(x)
  end

  def kgp_correlates_with_hgr_range(district_names)
    correlated = district_names.reduce(0) do |acc, district_name|
      acc + bool_to_binary[kgp_correlates_with_hgr_district(district_name)]
    end
     0.7 < correlated.to_f / district_names.length
  end

  def kindergarten_participation_correlates_with_high_school_graduation(options)
    if options[:for] == 'COLORADO'
      district_names = @district_repository.districts.keys - ['COLORADO']
      kgp_correlates_with_hgr_range(district_names)
    elsif options[:across]
      kgp_correlates_with_hgr_range(options[:across])
    else
      kgp_correlates_with_hgr_district(options[:for])
    end
  end

  def top_by_subject(options)   #(grade: 3, top:3, subject: math)
    response = list_scores_by_subject(options)[0..(options.fetch(:top,1)-1)]
    response.reject! {|d_v| d_v[1] == helper.not_enough_data}
    response = [:error, "No districts have sufficient data!"] if response.length == 0
    response.flatten! if response.length == 1
    response
  end

  def top_statewide_test_year_over_year_growth(options)  #(grade: 3, top:3, subject: math)
    if options[:subject]
      top_by_subject(options)
    else
      top_overall(options)
    end
  end

  def list_scores_by_subject(options) #(grade: 3, subject: :math)
    helper.detect_correct_inputs_for_year_growth_query(options)
    growth_values = district_names.map do |district|
      test_data = find_statewide_testing_by_name(district)
      test_hash = transpose_data(test_data.proficient_by_grade(options[:grade]))
      year_hash = test_hash[options[:subject]].reject{|year,value| value == "N/A"}
      response = helper.growth_value_over_range(year_hash)
      [district,response]
    end
    helper.sort_growth_values(growth_values)
  end


  def list_scores_by_overall(options)
    overall_rankings = total_districts.zip(Array.new(total_districts.length,0)).to_h
    subjects.each do |subject|
      ranks = list_scores_by_subject(query_options(subject, options[:grade])).to_h
      ranks.each do |dist,val|
        weighted_val = val * options.fetch(:weighting,{}).fetch(subject ,1.to_f/3)
        overall_rankings[dist] += weighted_val
      end
    end
    overall_rankings.keys.zip(overall_rankings.map{|k,v| truncate_value(v)}).to_h
  end

 # :weighting => {:math = 0.5, :reading => 0.5, :writing => 0.0})

  def top_overall(options)
    all_ranks = list_scores_by_overall(options)
    all_ranks = helper.remove_all_entries_with_insufficient_data(all_ranks)
    all_ranks = {error: "No districts have sufficient data!"} if all_ranks.length == 0
    top = helper.sort_growth_values(all_ranks.to_a)[0]
  end


  def total_districts
    @district_repository.districts.keys
  end

  def subjects
      [:math,:reading,:writing]
  end

  def query_options(subject,grade)
    {grade: grade, subject: subject}
  end
end
