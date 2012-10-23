$LOAD_PATH << "."
if ARGV.length !=1 
  puts "You must provide a CSV file name for this script"
  exit
end
require File.join(File.dirname(__FILE__), "..", "config", "boot")
require File.join(File.dirname(__FILE__), "..", "config", "environment")


lines = CoursesHelper.parse_csv_file(File.expand_path(ARGV[0])
lines.shift
print "Import #{lines.size} records"
scnt = CoursesHelper.load_courses(lines)
