$LOAD_PATH << "."
require "ar_support"

lines = EnrollmentsHelper.parse_csv_file(File.expand_path("./srenroll.csv"))
lines.shift
print "Import #{lines.size} records"
scnt = EnrollmentsHelper.load_enrollments(lines)
