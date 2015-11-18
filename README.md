# Headcount
## Turing Module 1: Final Projects
## Toni Rib & Aaron Greenspan

### Overview

Headcount uses real data from the [Colorado school districts](http://datacenter.kidscount.org/data#CO) which is separated into three categories: enrollment, statewide testing, and economic profile. The data is loaded from CSV files and assigned to instances of objects based on district name. Each district object contains only data related to that district.

The Headcount Analyst can then query data across districts to answer questions such as what is the top performing district in math, reading, or writing.

### Available Headcount Analyst Methods


#### Examples

The following is an example as run with [pry](https://github.com/pry/pry) from the command line in the base directory of the project:

```

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
