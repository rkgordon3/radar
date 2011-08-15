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
    lines.shift
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

private

  def parse_csv_file(path_to_csv)
    lines = []

    CSV.foreach(path_to_csv) do |row|
      lines << row
    end
    lines
  end

    def new_student(line)
	    logger.debug("Student line: " , line)
        params = Hash.new
        params[:student] = Hash.new
        params[:student]["student_id"] = line[0]
        params[:student]["first_name"] = line[1]
        if line[2].length > 0
            params[:student]["middle_initial"] = line[2][0]
        else
            params[:student]["middle_initial"] = "X"
        end
        params[:student]["last_name"] = line[3]
        params[:student]["full_name"] = line[1] + " " + line[2][0] + " " + line[3] rescue line[1] + " " + "X" + " " + line[3]
        params[:student]["classification"] = line[4]
        params[:student]["room_number"] = line[5]
        params[:student]["building_id"] = Building.where(:abbreviation => line[6]).first.id
        params[:student]["birthday"] = line[7][3..5] + line[7][0..2] + line[7][6..9] + " 8:00:00"
        params[:student]["extension"] = line[8][3..7]
        params[:student]["emergency_contact_name"] = line[10] + " " + line[9]
        params[:student]["emContact"] = line[14]
        params[:student]["affiliation"] = "SMU"
        url = UrlForId.where(:id => line[0]).first
        if url != nil
            url.url = line[16][34..line[16].length]
            url.save
        else
            url = UrlForId.new()
            url.id = line[0]
            url.url = line[16][34..line[16].length]
            url.save
        end    
        student = Student.where(:student_id => params[:student]["student_id"]).first
        student.update_attributes(params[:student]) rescue Student.create(params[:student])
    end
end