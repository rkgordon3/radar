class ImportsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource

  def new
    # @import automatically loaded by CanCan
	end

	def create
    respond_to do |format|
      if @import.save!
        flash[:notice] = 'CSV data was successfully imported.'
        format.html { redirect_to(@import) }
      else
        flash[:error] = 'CSV data import failed.'
        format.html { render :action => "new" }
      end
    end
	end

	def show
    # @import automatically loaded by CanCan
	end

	def proc_csv
    lines = parse_csv_file(@import.csv.path)
    lines.shift #comment this line out if your CSV file doesn't contain a header row
    if lines.size > 0
      @import.processed = lines.size
      lines.each do |line|
        case @import.datatype
        when "student"
          new_student(line)
        end
      end
      @import.save
      flash[:notice] = "CSV data processing was successful."
      redirect_to :action => "show", :id => @import.id
    else
      flash[:error] = "CSV data processing failed."
      render :action => "show", :id => @import.id
    end
	end

	
	  
  def is_legal_id? (id)
    (id != nil) && (id.length > 0) && ((id =~ /\D/) == nil)
  end
  
  def generate_image_url (raw)
	prefix_length = IMAGE_PATH.length rescue 0
	raw[prefix_length+1..raw.length]
  end
private

  def parse_csv_file(path_to_csv)
    lines = []

    CSV.foreach(path_to_csv) do |row|
      lines << row
    end
    lines
  end


    def new_student(line)
	    logger.debug("Student line: " + line[0])
	    if !is_legal_id?(line[0]) 
		    logger.debug("IMPORT ERROR. Skipping record with bad ID : >>#{line[0]}<<")
		    return
		end
        params = Hash.new
        params[:student] = Hash.new
        params[:student]["student_id"] = line[0]
        params[:student]["first_name"] = line[1]
        if not line[2].nil?
            params[:student]["middle_initial"] = line[2][0]
        else
            params[:student]["middle_initial"] = ""
        end
        if not line[3].nil?
            params[:student]["last_name"] = line[3]
        end
        params[:student]["full_name"] = line[1] + " " + line[2][0] + " " + line[3] rescue line[1] + " " + "" + " " + line[3]
        params[:student]["classification"] = line[4]
        
        params[:student]["building_id"] = Building.where(:abbreviation => line[6]).first.id
		params[:student]["room_number"] = line[5]
        if not line[7].nil?
            birthday = line[7].split('/')
            birthday[0] = birthday[0].rjust(2, '0')
            birthday[1] = birthday[1].rjust(2, '0')
            params[:student]["birthday"] = birthday[1] + "/" + birthday[0] + "/" + birthday[2] + " 8:00:00"
        end
        if not line[8].nil?
            params[:student]["extension"] = line[8][3..7]
        end
        if not line[10].nil?
            params[:student]["emergency_contact_name"] = line[10] + " " + line[9]
        end
        if not line[14].nil?
            params[:student]["emContact"] = line[14]
        end
        params[:student]["affiliation"] = CLIENT_AFFILIATION_TAG
		
        if not line[16].nil?
            url = UrlForId.where(:id => line[0]).first
            if url == nil
                url = UrlForId.new()
                url.id = line[0]
            end
			url.url = generate_image_url(line[16])
            url.save
        end
        if not line[17].nil?
            params[:student]["email"] = line[17]
        end
        student = Student.where(:student_id => params[:student]["student_id"]).first
        student.update_attributes(params[:student]) rescue Student.create(params[:student])
    end
end