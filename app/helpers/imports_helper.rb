module ImportsHelper
	
	
	class Helpers
		
		
	    @@error_messages = []
		
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
			if not input_url.nil?
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

		# Create/update a student from an array 
		def self.build_student_params(line)
			puts ("Student line: " + line[0])
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
			if not line[7].nil?
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
			if not line[14].nil?
				params["emContact"] = line[14]
			end
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
			puts "Update student #{params}"
			student = Student.where(:student_id => params["student_id"]).first
			if not student.nil?  
				raise "Error updating #{params[:student_id]}" if !student.update_attributes(params)
				#student.save
			else 
				puts "error Creating new student record for #{params[:student_id]}"
				raise "Error creating #{params[:student_id]}" if Student.create(params).nil? 
			end
		end
	end
	
	
	# Each entry in lines array contains a line from CSV. An element in 'lines' is another
	# array, one entry for each column in CSV.
	# Returns number of successful imports
	def ImportsHelper.load_students(lines)
		Helpers.error_messages.clear
		successful_lines = 0

		lines.each do |line|
			begin 
				params = Helpers.build_student_params(line)
				Helpers.update_student(params)
				successful_lines += 1
			rescue 
				Helpers.add_error_message( $!)
			end
			
		end
		successful_lines
	end
	

	
	# Read from CSV file at given path and return an array of arrays.
	def ImportsHelper.parse_csv_file(path_to_csv)
		lines = []

		CSV.foreach(path_to_csv) do |row|
			lines << row
		end
		if !Helpers.is_legal_id?(lines[0][0])
		   lines.shift
		end 
		lines
	end
  
	
end
