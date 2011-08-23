module ImportsHelper
	
	
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
			#puts ("Student line: " + line[0])
			if !is_legal_id?(line[0]) 
				raise ArgumentError, "IMPORT Bad ID #{line[0]}"
			end

			params = Hash.new
			params["student_id"] = line[0]
			params["first_name"] = line[1]
			if not line[2].nil?
				params["middle_initial"] = line[2][0]
			else
				params["middle_initial"] = ""
			end
			if not line[3].nil?
				params["last_name"] = line[3]
			end
			params["full_name"] = line[1] + " " + line[2][0] + " " + line[3] rescue line[1] + " " + "" + " " + line[3]
			params["classification"] = line[4]
			
			params["building_id"] = Building.where(:abbreviation => line[6]).first.id
			params["room_number"] = line[5]
			if is_legal_dob?(line[7])
				birthday = line[7].split('/')
				birthday[0] = birthday[0].rjust(2, '0')
				birthday[1] = birthday[1].rjust(2, '0')
				params["birthday"] = birthday[1] + "/" + birthday[0] + "/" + birthday[2] + " 8:00:00"
			end
			if not line[8].nil?
				params["extension"] = line[8][3..7]
			end
			if not line[10].nil?
				params["emergency_contact_name"] = line[10] + " " + line[9]
			end
			emphone = ""
			if (not line[13].nil?) && (line[13].strip.length > 0)
				emphone << "C:#{line[13]}"
			end
			if (not line[14].nil?) && (line[14].strip.length > 0)
				emphone << " D:#{line[14]}" 
			end
			emphone << line[15] if emphone.strip.length == 0
			
			params["emContact"] = emphone
			
			params["affiliation"] = CLIENT_AFFILIATION_TAG
			
			# id, url
			update_url(line[0], line[16])
		   
			if not line[17].nil?
				params["email"] = line[17]
			end
			params
		end
		
		# create/update student from params hash
		def self.update_student(params)
			student = Student.where(:student_id => params["student_id"]).first
			if not student.nil?  
				raise "Error updating #{params[:student_id]}" if !student.update_attributes(params)
				
				@@update_count += 1
				#student.save
			else 
				raise "Error creating #{params[:student_id]}" if Student.create(params).nil? 
				@@new_count += 1
			end
		end
	end
	
	
	# Each entry in lines array contains a line from CSV. An element in 'lines' is another
	# array, one entry for each column in CSV.
	# Returns number of successful imports
	def ImportsHelper.load_students(lines)
		record_cnt = 0
		Helpers.reset
		successful_lines = 0

		lines.each do |line|
			begin 
			    raise  "Empty record" if line.nil? || line.empty?
				params = Helpers.build_student_params(line)
				Helpers.update_student(params)
				successful_lines += 1
				
			rescue 
				Helpers.add_error_message( "Record #{record_cnt} : #{$!}")
			end
			record_cnt += 1
            print "."
		end
        puts
		successful_lines
	end
	

	
	# Read from CSV file at given path and return an array of arrays.
	def ImportsHelper.parse_csv_file(path_to_csv)
		lines = []

		CSV.foreach(path_to_csv) do |row|
			lines << row
		end
		
		lines
	end
  
	
end
