set ts=%date:~-4%_%date:~4,2%_%date:~7,2%
copy shradar.csv shradar.csv.%ts%
copy shradarwdraw.csv shradarwdraw.csv.%ts%
ftp -s:ftp_cmds
echo %1
ruby load_students.rb %1
ruby drop_students.rb %1
rem ruby load_courses.rb %1
rem ruby load_enrollments.rb %1
