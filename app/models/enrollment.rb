class Enrollment < ActiveRecord::Base
    def Enrollment.for (student)
        where(:student_id => student.student_id)
    end
    def description
        Course.where(:id => self.course_id).first.display_name
    end
end
