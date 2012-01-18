ftp -s:ftp_students.txt
echo %1
ruby load_students.rb %1
ruby drop_students.rb %1
ruby load_courses.rb %1
ruby load_enrollments.rb %1
