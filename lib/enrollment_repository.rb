

# The EnrollmentRepository is responsible for holding and searching our Enrollment instances. It offers the following methods:
#
# find_by_name - returns either nil or an instance of Enrollment having done a case insensitive search
# For iteration 0, the instance of this object represents one line of data from the file Kindergartners in full-day program.csv. It's initialized and used like this:
#
# er = EnrollmentRepository.new
# er.load_data({
#   :enrollment => {
#     :kindergarten => "./data/Kindergartners in full-day program.csv"
#   }
# })
# enrollment = er.find_by_name("ACADEMY 20")
# # => <Enrollment>
