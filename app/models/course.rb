class Course < ActiveRecord::Base

    def display_name
        self.department + " " + self.course_number + self.section
    end
    def description
        self.display_name
    end
end
