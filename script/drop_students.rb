$LOAD_PATH << "."
require "ar_support"

lines = ImportsHelper.parse_csv_file(File.expand_path("./shradarwdraw.csv"))
lines.shift
print "Process #{lines.size} drop records"
scnt = ImportsHelper.deactivate_students(lines)
