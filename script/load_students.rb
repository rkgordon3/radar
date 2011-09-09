$LOAD_PATH << "."
require "ar_support"

lines = ImportsHelper.parse_csv_file(File.expand_path("./shradar.csv"))
lines.shift
print "Import #{lines.size} records"
scnt = ImportsHelper.load_students(lines)
puts "Successfully imported #{scnt} records. #{lines.size-scnt} failures."
puts ImportsHelper::Helpers.stats
puts "ERROR MESSAGES:"
puts ImportsHelper::Helpers.error_messages
