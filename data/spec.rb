
    # find_by_name - returns either nil or an instance of District having done a case insensitive search
    # find_all_matching - returns either [] or one or more matches which contain the supplied name fragment, case insensitive


dr = DistrictRepository.new
dr.load_data(:kindergarten => "./data/Kindergartners in full-day program.csv")
district = dr.find_by_name("ACADEMY 20")
# => <District>


d = District.new({:name => "ACADEMY 20"})
d.name = "ACADEMY 20"

er = EnrollmentRepository.new
er.load_data(:kndergarten => "./data/Kindergartners in full-day program.csv")
enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>


e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})

e.kindergarten_participation_by_year
# => { 2010 => 0.391,
#      2011 => 0.353,
#      2012 => 0.267,
#    }

e.kindergarten_participation_in_year(2010)
# => 0.391

dr = DistrictRepository.new
dr.load_data('./data')
district = dr.find_by_name("ACADEMY 20")

district.enrollment.kindergarten_participation_in_year(2010) # => 0.391

ha = HeadcountAnalyst.new(dr)

ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO') # => 0.766
