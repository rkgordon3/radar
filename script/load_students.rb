lines = ImportsHelper.parse_csv_file("script/shradar.csv")
lines.shift
puts "Import #{lines.size} records"
scnt = ImportsHelper.load_students(lines)
puts "Successfully imported #{scnt} records. #{lines.size-scnt} failures."