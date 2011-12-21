$LOAD_PATH << "."
require "ar_support"

lines = CoursesHelper.parse_csv_file(File.expand_path("./srcrsect.csv"))
lines.shift
print "Import #{lines.size} records"
scnt = CoursesHelper.load_courses(lines)
