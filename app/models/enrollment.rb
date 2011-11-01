class Enrollment < ActiveRecord::Base
    def Enrollment.for (students)
        query = ""
        students.each do |s|
            query += "Enrollment.find_by_sql('select course_id from enrollments where student_id = #{s.student_id}') & "
        end
        eval(query[0..query.length - 4])
    end
    def description
        Course.where(:id => self.course_id).first.display_name
    end
end
