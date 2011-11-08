class Enrollment < ActiveRecord::Base
    def Enrollment.for (students)
        query = ""
        course_ids = Array.new
        students.each do |s|
            query += "SELECT course_id FROM enrollments where student_id = #{s.student_id} group by course_id intersect "
        end
        results = ActiveRecord::Base.connection.execute(query[0..query.length-11])
        results.each do |r|
            course_ids << r['course_id']
        end
        logger.debug "!!!!!!!!!!!!!!!!"
        logger.debug course_ids
        Course.find_all_by_id(course_ids)
    end
    
    
end

#def Enrollment.for (students)
#        query = ""
#        students.each do |s|
#            query += "Enrollment.find_by_sql('select course_id from enrollments where student_id = #{s.student_id}') & "
#        end
#        eval(query[0..query.length - 4])
#end


