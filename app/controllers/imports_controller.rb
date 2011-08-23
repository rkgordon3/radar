class ImportsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource

	def new
		# @import automatically loaded by CanCan
	end

	def create
	

		respond_to do |format|
			if @import.save!
				flash[:notice] = 'CSV data was successfully uploaded.'
				format.html { redirect_to(@import) }
			else
				flash[:error] = 'CSV upload failed.'
				format.html { render :action => "new" }
			end
		end

	end

	def show
    # @import automatically loaded by CanCan
	end

	def proc_csv
		lines = ImportsHelper.parse_csv_file(@import.csv.path)
		logger.debug "#{lines} read from #{@import.csv.path}"
        case @import.datatype
			when "student"
			    # skip first line if it looks like a header
			    if !ImportsHelper::Helpers.is_legal_id?(lines[0][0])
		          lines.shift
				end 
				@import.processed = ImportsHelper.load_students(lines)
			end
		 
		@import.save
		session[:import_errors] = ImportsHelper::Helpers.error_messages
		flash[:notice] = "Imported #{@import.processed} of #{lines.size} records."
		redirect_to :action => "show", :id => @import.id
	end
	 
end