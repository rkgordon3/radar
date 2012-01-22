class Enrollment < ActiveRecord::Base
	
    def Enrollment.for (students)
	# For each student, find courses, build an array of course_id arrays 
	# then use inject to do an intersection on the course_id arrays
		Course.find_all_by_id(students.collect { |s| Enrollment.where(:student_id=>s.student_id).all.collect { |e| e.course_id } }.inject { |a,b| a & b } )
    end     
end


