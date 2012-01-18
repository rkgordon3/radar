module CoursesHelper
    DEPARTMENT = 1
    COURSE_NUMBER = 2
    SECTION = 3
    TERM = 0
    DESCRIPTION = 4

    class Helpers
		@@error_messages = []
		@@update_count = 0
		@@new_count = 0
        def self.stats
		  "Update Count #{@@update_count} New Count #{@@new_count}"	  
		end
		
		def self.reset
			@@error_messages = []
			@@update_count = 0
			@@new_count = 0
		end
        
        def self.error_messages=(arg)
		   @@error_messages = arg
		end
		
		def self.error_messages
		  @@error_messages
		end
		
		def self.add_error_message(arg)
		  @@error_messages << arg
		end
        
        def self.build_course_params(line)
            params = Hash.new
            params["department"] = line[DEPARTMENT]
            params["course_number"] = line[COURSE_NUMBER]
            params["section"] = line[SECTION]
            params["semester"] = line[TERM][4..6]
            params["year"] = line[TERM][0..4]
            params["term"] = line[TERM]
			params["full_name"] = line[DEPARTMENT] + line[COURSE_NUMBER] +line[DESCRIPTION] + line[TERM]
            params            
        end
        
        def self.update_course(params)
            course = Course.where(:department => params["department"], :section => params["section"], :course_number => params["course_number"], :term => params["term"]).first
			if not course.nil?  
				raise "Error updating #{course.id} #{params["full_name"]}" if !course.update_attributes(params)
				@@update_count += 1
			else 
				raise "Error creating #{params["full_name"]}" if Course.create(params).nil? 
				@@new_count += 1
			end
			course
        end
    end
    
    # Read from CSV file at given path and return an array of arrays.
	def CoursesHelper.parse_csv_file(path_to_csv)
		lines = []

		CSV.foreach(path_to_csv) do |row|
		    puts "Processing line #{lines.size}"
			lines << row
		end
		
		lines
	end
    
    # Each entry in lines array contains a line from CSV. An element in 'lines' is another
	# array, one entry for each column in CSV.
	# Returns number of successful imports
	def CoursesHelper.load_courses(lines)
		reset
        log = File.new("courses_import.log", "a")
		log.puts "************** logging session started at #{Time.now} "
		lines.each do |line|
		    log.puts "Processing #{line}"
			begin 
			    raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_course_params(line)
				Helpers.update_course(params)
				@@successful_lines += 1
			rescue 
				Helpers.add_error_message( "Record #{@@record_cnt} : #{$!}")
			end
			@@record_cnt += 1
            print "."
		end
        puts
		@@successful_lines
		log.puts "Import #{lines.size} records"

		log.puts "Successfully imported #{@@successful_lines} records. #{lines.size-@@successful_lines} failures."
		log.puts CoursesHelper::Helpers.stats
		log.puts "ERROR MESSAGES:"
		log.puts CoursesHelper::Helpers.error_messages

		log.close
	end
        
    private
    def CoursesHelper.reset 
        @@record_cnt = 0
        Helpers.reset
        @@successful_lines = 0
    end
end
