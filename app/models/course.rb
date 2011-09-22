class Course < ActiveRecord::Base

    def display_name
        self.department + " " + self.course_number + self.section
    end
end
