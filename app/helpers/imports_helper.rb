module ImportsHelper
	require 'csv'

	STUDENT_ID_INDEX = 0
	FN_INDEX = 1
	MI_INDEX = 2
	LN_INDEX = 3
	CLASS_INDEX = 4
	ROOM_INDEX = 5
	BUILDING_INDEX = 6
	DOB_INDEX = 7
	EXT_INDEX = 8
	EMERG_CONTACT_LN_INDEX = 9
	EMERG_CONTACT_FN_INDEX = 10
	EMERG_CELL_INDEX = 13
	DAY_PHONE_INDEX = 14
	NIGHT_PHONE_INDEX = 15
	IMAGE_URL_INDEX = 16
	EMAIL_INDEX = 17
	
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

		def self.generate_image_url (raw)
			prefix_length = IMAGE_PATH.length rescue 0
			# sub any \ with / 
			raw[prefix_length..raw.length].gsub(/\\/, "/")
		end
	
	
		def self.update_url(id, input_url) 
			if (not input_url.nil?) && input_url.length > IMAGE_PATH.length
				url = UrlForId.where(:id => id).first
				if url == nil
					url = UrlForId.new()
					url.id = id
				end
				url.url = generate_image_url(input_url)
				url.save
			end
		end
		
		def self.is_legal_id? (id)
			(id != nil) && (id.length > 0) && ((id =~ /\D/) == nil)
		end
		
		def self.is_legal_dob? (dob)
		  (not dob.nil?) && ((dob =~ /^(0?[1-9]|1[012])\/(0?[1-9]|[12][1-9]|3[01])\/(19|2[0-9])\d\d$/) == 0)
		end

		# Create/update a student from an array 
		def self.build_student_params(line)
			puts ("build_student_params : " + line[0])
			if !is_legal_id?(line[STUDENT_ID_INDEX]) 
				raise ArgumentError, "IMPORT Bad ID #{line[STUDENT_ID_INDEX]}"
			end

			params = Hash.new
			params["student_id"] = line[STUDENT_ID_INDEX]
			
			return params if line.length == FN_INDEX
			
			params["first_name"] = line[FN_INDEX] 
			
			return params if line.length == MI_INDEX
			
			if not line[MI_INDEX].nil?
				params["middle_initial"] = line[MI_INDEX][0]
			else
				params["middle_initial"] = ""
			end
			
			return params if line.length == LN_INDEX
			
			if not line[LN_INDEX].nil?
				params["last_name"] = line[LN_INDEX]
			end
			params["full_name"] = params["first_name"]  + " " + params["last_name"]
			params["classification"] = line[CLASS_INDEX]

      #building_index = "RSM" if line[BUILDING_INDEX] == "NV"
      building_index ||= line[BUILDING_INDEX]
			params["building_id"] = Building.where(:abbreviation => building_index).first.id rescue Building.unspecified_id
			params["room_number"] = line[ROOM_INDEX]
			if is_legal_dob?(line[DOB_INDEX])
				birthday = line[DOB_INDEX].split('/')
				birthday[0] = birthday[0].rjust(2, '0')
				birthday[1] = birthday[1].rjust(2, '0')
				params["birthday"] = birthday[1] + "/" + birthday[0] + "/" + birthday[2] + " 8:00:00"
			end
			if not line[EXT_INDEX].nil? && line[EXT_INDEX].length > 7
				params["extension"] = line[EXT_INDEX][3..7]
			end
			if not line[EMERG_CONTACT_FN_INDEX].nil?
				params["emergency_contact_name"] = line[EMERG_CONTACT_FN_INDEX] + " " + line[EMERG_CONTACT_LN_INDEX]
			end
			emphone = ""
			if (not line[EMERG_CELL_INDEX].nil?) && (line[EMERG_CELL_INDEX].strip.length > 0)
				emphone << "C:#{line[EMERG_CELL_INDEX]}"
			end
			if (not line[DAY_PHONE_INDEX].nil?) && (line[DAY_PHONE_INDEX].strip.length > 0)
				emphone << " D:#{line[DAY_PHONE_INDEX]}" 
			end
			emphone << line[NIGHT_PHONE_INDEX] if emphone.strip.length == 0
			
			params["emContact"] = emphone
			
			params["affiliation"] = CLIENT_AFFILIATION_TAG
			
			# id, url
			begin
			 update_url(params["student_id"], line[IMAGE_URL_INDEX])
			rescue => e
			 puts e.backtrace.join("\n")
			end
		   
			if not line[EMAIL_INDEX].nil?
				params["email"] = line[EMAIL_INDEX]
			end
			
			params["is_active"] = true
			params
		end
		
		
		def self.deactivate_student(params)
			student = Student.where(:student_id => params["student_id"]).first
			puts " FOUND #{student.student_id}"  unless student.nil?
			if not student.nil?
			  
				student.is_active = false
				student.affiliation = "Former Student"
				student.building_id = nil
				student.room_number = nil
				student.extension = nil
				student.classification = nil
				student.save
			end
			student
		end
		# create/update student from params hash
		def self.update_student(params)
			puts "entry update_student " + params["student_id"]
			student = Student.where(:student_id => params["student_id"]).first
			if not student.nil?  
				puts "update_student: updating student " + params["student_id"]
				raise "Error updating #{params[:student_id]}" if !student.update_attributes(params)
				
				@@update_count += 1
			else 
				puts "update_student could not find: " + params["student_id"]
				raise "Error creating #{params[:student_id]}" if Student.create(params).nil? 
				@@new_count += 1
			end
			student
		end
	end
	
	
	# Each entry in lines array contains a line from CSV. An element in 'lines' is another
	# array, one entry for each column in CSV.
	# Returns number of successful imports
	def ImportsHelper.load_students(lines)
		reset
		log = File.new("import.log", "a")
		log.puts "**************Import logging session started at #{Time.now} "
		lines.each do |line|
		log.puts "Processing #{line}"
			begin 
				raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_student_params(line)
				Helpers.update_student(params)
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
		log.puts ImportsHelper::Helpers.stats
		log.puts "ERROR MESSAGES:"
    log.puts ImportsHelper::Helpers.error_messages
    
		log.close

    return "Successfully imported #{@@successful_lines} records. #{lines.size-@@successful_lines} failures."
    
	end

  def ImportsHelper.mail_load_results(load_results)
    message = load_results + "\n" + ImportsHelper::Helpers.stats
    message = message + "\n" + "ERROR MESSAGES:"
	message = message + "\n" + ImportsHelper::Helpers.error_messages.join("\n")

    begin
      RadarMailer.generic_mail("RADAR Import Results", message, system_status_email).deliver
    rescue => e
	  puts e.backtrace.join("\n")
      puts "Failed to send mail #{$!}"
	  puts "************************"
	  puts message
	  puts "************************"

    end
  end
	

	def ImportsHelper.deactivate_students(lines)
    log = File.new("import.log", "a")
    log.puts "**************Drop logging session started at #{Time.now} "
		reset
		lines.each do |line|
			begin
				raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_student_params(line)				
				Helpers.deactivate_student(params)
				@@successful_lines += 1
			rescue
				Helpers.add_error_message( "Record #{@@record_cnt} : #{$!}")
			end 
			@@record_cnt += 1
			print "."
		end
		puts
		@@successful_lines
		log.puts "Processed #{lines.size} records"

		log.puts "Successfully processed #{@@successful_lines} records. #{lines.size-@@successful_lines} failures."
		log.puts ImportsHelper::Helpers.stats
		log.puts "ERROR MESSAGES:"
		log.puts ImportsHelper::Helpers.error_messages

		log.close
	end
	
	# Read from CSV file at given path and return an array of arrays.
	def ImportsHelper.parse_csv_file(path_to_csv)
		lines = []
    
    begin
      CSV.foreach(path_to_csv) do |row|
		    puts "Processing line #{lines.size}"
        lines << row
      end
    rescue => e
      begin

        RadarMailer.generic_mail("RADAR Import CSV Parsing Error", "The CSV file failed to parse line #{lines.size}.", system_status_email).deliver
      rescue => e
        puts e.backtrace.join("\n")
        puts "Failed to send mail #{$!}"
      end
      puts e.backtrace.join("\n")
      puts "Error parsing #{row}"
    end
    
		lines
	end
	
	# each_student { |x| Helpers.deactivate_student(x) }
	
	def ImportsHelper.each_student (lines, &code)
		reset
		lines.each do |line|
			begin
				raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_student_params(line)				
				yield params
				successful_lines += 1
			rescue
				Helpers.add_error_message( "Record #{@@record_cnt} : #{$!}")
			end 
			@@record_cnt += 1
			print "."
		end
		puts
		@@successful_lines
	end
	
	private
	def ImportsHelper.reset 
		@@record_cnt = 0
		Helpers.reset
		@@successful_lines = 0
  end
	
  
	
end
