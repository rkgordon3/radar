$LOAD_PATH << "."
require "ar_support"

lines = ImportsHelper.parse_csv_file(File.expand_path("./shradar.csv"))
lines.shift
print "Import #{lines.size} records"
load_results = ImportsHelper.load_students(lines)
ImportsHelper.mail_load_results(load_results)
