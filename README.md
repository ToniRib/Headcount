# Headcount
## Turing Module 1: Final Projects
## Toni Rib & Aaron Greenspan

### Overview

Headcount uses real data from the [Colorado school districts](http://datacenter.kidscount.org/data#CO) which is separated into three categories: enrollment, statewide testing, and economic profile. The data is loaded from CSV files and assigned to instances of objects based on district name. Each district object contains only data related to that district.

The Headcount Analyst can then query data across districts to answer questions such as what is the top performing district in math, reading, or writing.

### Available Headcount Analyst Methods

* __district_names:__ Returns all district names that have been loaded into the District Repository
* __find_enrollment_by_name(name):__ Returns the Enrollment object for a given District
* __find_swtest_by_name(name):__ Returns the StatewideTest object for a given District
* __highschool_graduation_rate_variation(district_name, vs):__ returns the average enrollment for a given district divided by the state average
* __kindergarten_participation_rate_variation_trend(district_name, vs):__ same as above but broken down year-by-year
* __kindergarten_participation_against_high_school_graduation(district_name):__ returns the average kindergarten participation divided by the high school graduation rate (for a given district evaluated against the state)
* __kindergarten_participation_correlates_with_high_school_graduation(options):__ returns true or false based on whether kindergarten participation is correlated to high school graduation. Can be done for either a single district or the whole state. If the value is between 0.6 and 1.5 then the result is true.
* __top_statewide_test_year_over_year_growth(options):__ Take a variety of inputs and determines an overall winner or list of winners. Example inputs can be a specific grade, grade & subject, or grade and weights for each subject.

#### Examples

The following is an example as run with [pry](https://github.com/pry/pry) from the command line in the base directory of the project:

```
[1] pry(main)> require_relative 'lib/headcount_analyst'
=> true

[2] pry(main)> dr = DistrictRepository.new
=> #<DistrictRepository:0x007f927d8d50d8
 @districts={},
 @economic_profile_repo=
  #<EconomicProfileRepository:0x007f927d8d4f98 @profiles={}>,
 @enrollment_repo=#<EnrollmentRepository:0x007f927d8d5060 @enrollments={}>,
 @statewide_test_repo=
  #<StatewideTestRepository:0x007f927d8d5010 @statewide_tests={}>>

[3] pry(main)> dr.load_data(
[3] pry(main)*   :economic_profile => {
[3] pry(main)*     :median_household_income => "./data/Median household income.csv",
[3] pry(main)*     :children_in_poverty => "./data/School-aged children in poverty.csv",
[3] pry(main)*     :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
[3] pry(main)*     :title_i => "./data/Title I students.csv"
[3] pry(main)*   },
[3] pry(main)*   :statewide_testing => {
[3] pry(main)*     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
[3] pry(main)*     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
[3] pry(main)*     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
[3] pry(main)*     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
[3] pry(main)*     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
[3] pry(main)*   },
[3] pry(main)*   :enrollment => {
[3] pry(main)*     :kindergarten => "./data/Kindergartners in full-day program.csv",
[3] pry(main)*     :high_school_graduation => "./data/High school graduation rates.csv"
[3] pry(main)*   }
[3] pry(main)* )
 << response omitted for brevity >>

[4] pry(main)> ha = HeadcountAnalyst.new(dr)
 << response omitted for brevity >>

[5] pry(main)> ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
=> 0.766

[6] pry(main)> ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
=> 0.447

[7] pry(main)> ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
=> {2007=>0.992,
2006=>1.05,
2005=>0.96,
2004=>1.257,
2008=>0.717,
2009=>0.652,
2010=>0.681,
2011=>0.727,
2012=>0.688,
2013=>0.694,
2014=>0.661}

[8] pry(main)> ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
=> 0.641

[9] pry(main)> ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
=> true

[10] pry(main)> ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
=> false

[11] pry(main)> ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ['ACADEMY 20', 'ADAMS COUNTY 14', 'ARRIBA-FLAGLER C-20', 'CROWLEY COUNTY RE-1-J'])
=> false

[12] pry(main)> ha.top_statewide_test_year_over_year_growth(subject: :math)
InsufficientInformationError: A grade must be provided to answer this question
from /Users/tonirib/turing/projects/1-mod/headcount/lib/headcount_analyst.rb:156:in `raise_insufficient_info_error'

[13] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
=> ["WILEY RE-13 JT", 0.3]

[14] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
=> ["OURAY R-1", 0.242]

[16] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
=> ["WILEY RE-13 JT", 0.3]

[17] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
=> [["WILEY RE-13 JT", 0.3],
 ["SANGRE DE CRISTO RE-22J", 0.071],
 ["COTOPAXI RE-3", 0.07]]

[18] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 3)
=> ["SANGRE DE CRISTO RE-22J", 0.071]

[19] pry(main)> ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
=> ["OURAY R-1", 0.153]
```

### Test Suite

All classes each have a corresponding testing file written with [minitest](https://github.com/seattlerb/minitest) which can be run from the terminal using mrspec:

```
$ mrspec test/median_household_income_test.rb

MedianHouseholdIncome
  estimated income handles nas by rejecting them
  returns false if year above range
  average median handles nas by rejecting them all
  can calculate median household income in a year
  estimated income handles nas by rejecting them all
  returns true if year at bottom of range
  can be initialized with data and a name
  averages median values
  can be initialized with name only and nil data
  average median handles nas by rejecting them
  returns true if year at top of range
  returns true if year within range
  class exists
  returns false if year below range
  raises unknown data error if year does not exist

Failures:

Finished in 0.00274 seconds (files took 0.22014 seconds to load)
15 examples, 0 failures
```

You can also run all the tests at the same time by running the `mrspec` command from the terminal in the project's base directory.

#### Dependencies

Must have the [mrspec gem](https://github.com/JoshCheek/mrspec) and [minitest gem](https://github.com/seattlerb/minitest) installed.
