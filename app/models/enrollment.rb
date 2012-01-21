class Enrollment < ActiveRecord::Base
	
    def Enrollment.for (students)
		enrollments = []
        students.each do |s|
			enrollments << Enrollment.where(:student_id => s.student_id).all.collect { |e| e.course_id }
        end

		sz = enrollments.size-1
		while sz > 0
			enrollments[0] = enrollments[0] & enrollments[sz]
			sz = sz -1
		end
        Course.find_all_by_id(enrollments[0])
    end     
end


