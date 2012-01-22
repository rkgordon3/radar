class Enrollment < ActiveRecord::Base
	
    def Enrollment.for (students)
		Course.find_all_by_id(students.collect { |s| Enrollment.where(:student_id=>s.student_id).all.collect { |e| e.course_id } }.inject { |a,b| a & b } )
    end     
end


