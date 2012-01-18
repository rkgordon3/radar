module EnrollmentsHelper
    STUDENT_ID = 0
    DEPARTMENT = 2
    COURSE_NUMBER = 3
    SECTION = 4
    TERM = 1
    
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
        
        def self.build_enrollment_params(line)
            params = Hash.new
            params["student_id"] = line[STUDENT_ID]
            params["course_id"] = Course.where(:department => line[DEPARTMENT], :section => line[SECTION], :course_number => line[COURSE_NUMBER], :term => line[TERM]).first.id rescue nil
            params
        end
        
        def self.update_enrollment(params)
            enrollment = Enrollment.where(:course_id => params["course_id"], :student_id => params["student_id"]).first
			if not enrollment.nil?  
				raise "Error updating #{enrollment.id}" if !enrollment.update_attributes(params)
				@@update_count += 1
			else 
				raise "Error creating course #{params["course_id"]} enrollment for #{params["student_id"]}" if Enrollment.create(params).nil? 
				@@new_count += 1
			end
			enrollment
        end
    end
    
    # Read from CSV file at given path and return an array of arrays.
	def EnrollmentsHelper.parse_csv_file(path_to_csv)
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
	def EnrollmentsHelper.load_enrollments(lines)
		reset
        log = File.new("enrollments_import.log", "a")
		log.puts "************** logging session started at #{Time.now} "
		lines.each do |line|
		    log.puts "Processing #{line}"
			begin 
			    raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_enrollment_params(line)
				Helpers.update_enrollment(params)
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
		log.puts EnrollmentsHelper::Helpers.stats
		log.puts "ERROR MESSAGES:"
		log.puts EnrollmentsHelper::Helpers.error_messages

		log.close
	end
        
    private
    def EnrollmentsHelper.reset 
        @@record_cnt = 0
        Helpers.reset
        @@successful_lines = 0
    end
end
