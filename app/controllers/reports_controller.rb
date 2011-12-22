class ReportsController < ApplicationController
  before_filter :authenticate_staff!
  load_resource :except => :remove_participant
  authorize_resource
  load_and_authorize_resource :incident_report
  rescue_from Errno::ECONNREFUSED, :with => :display_error
  
  def index
    if (params[:report].nil?) 
      params[:report] = "Report"
    end
    @reports = Kernel.const_get(params[:report]).accessible_by(current_ability).paginate(:page => params[:page], :per_page => 30)
    report_type = ReportType.find_by_name(params[:report])
	  
    params[:sort] ||= "approach_time"
    
    @reports = Report.sort(@reports,params[:sort])
    respond_to do |format|
      format.html { render :locals => { :reports => @reports, :report_type => report_type } }
      format.xml  { render :xml => @reports }
      format.js
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    session[:report] = @report

    # add entry to view log if one does not exist for this staff/report combination
    current_staff.has_seen?(@report) || ReportViewLog.create(:staff_id => current_staff.id, :report_id=> @report.id)
    # get the interested parties to email for this report type
    @interested_parties = InterestedParty.where(:report_type_id=>@report.type_id)


    respond_to do |format|
      format.html { render 'reports/show' }
      format.iphone { render 'reports/show', :layout => 'mobile_application' }
      format.pdf { render :pdf => "#{@report.tag}", :template=> "reports/show.pdf.erb", :stylesheets => ["radar_pdf"] }
    end
  end
  
  def new_with_participants
	report_name = params[:report_type]
	@report = report_name.constantize.new(:staff_id => current_staff.id) 
    session[:report] = @report
    if (params[:participants] != nil)
      @report.add_participants(params[:participants])
    end
	respond_to do |format|
      format.html { render 'reports/new' }
      format.iphone { render "reports/new", :layout => 'mobile_application' }
    end 
  end
  
  
  # GET /reports/new
  # GET /reports/new.xml
  def new
    session[:report] = @report

    respond_to do |format|
      format.html { render "reports/new" }
      format.iphone { render "reports/new", :layout => 'mobile_application' }
    end
  end
  
  # GET /reports/1/edit
  def edit
    session[:report]=@report

    @report_adjuncts = ReportAdjunct.find_all_by_report_id(@report.id)

    respond_to do |format|
      format.html { render 'reports/edit' }
      format.iphone { render "reports/edit", :layout => 'mobile_application' }
    end
  end
  
  # POST /reports
  # POST /reports.xml
  def create
    @report = session[:report]
    params[:report][:report_adjuncts] = params[:report_adjuncts]

    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        if can? :show, @report
          format.html { redirect_to(@report, :notice => 'Report was successfully created.') }
        else
          format.html { redirect_to({:action => 'index', :controller => 'reports', :report => @report.type}, :notice => 'Report was successfully created.') }
        end
        format.xml  { render :xml => @report, :status => :created, :location => @report }
        format.iphone {redirect_to(@report)}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
        format.iphone {render :layout => 'mobile_application'}
      end
    end
  end
  
  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    params[:report][:report_adjuncts] = params[:report_adjuncts]

    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        if can? :show, @report
          format.html { redirect_to(@report, :notice => 'Report was successfully updated.') }
        else
          format.html { redirect_to({:action => 'index', :controller => 'reports', :report => @report.type}, :notice => 'Report was successfully updated.') }
        end
        format.xml  { head :ok }
        format.iphone { redirect_to("/home/landingpage", :notice => "Report updated" ) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report.destroy
    
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
  
  def add_participant
    @participant = Participant.find(params[:participant][:id]) if param_value_present(params[:participant][:id]) 
    @report = session[:report]

    if not defined? @participant
	
      name_tokens = params[:full_name].split(' ')
      first_name = name_tokens[0].capitalize
      if (name_tokens.length > 2)
        middle_initial = name_tokens[1].capitalize
      end
      last_name = name_tokens[name_tokens.length-1].capitalize
      
      respond_to do |format|
        format.js{
          render :update do |page|
            page.select("input#full_name").first.clear
            page.replace_html "new-part-div", :partial => "participants/new_participant_partial", :locals => { :fName => first_name, :mInitial => middle_initial, :lName => last_name }
			
            if @report.participant_ids.size > 1
              page.show 'common-reasons-container'
            end
          end
        }
      end
    else
      insert_new_participant_partial = !@report.associated?(@participant)
      @report.add_default_contact_reason(@participant.id)
      respond_to do |format|
        format.js
        format.iphone {
          render :update do |page|
            if insert_new_participant_partial
              @report.add_default_contact_reason(@participant.id)
              page.select("input#full_name").first.clear
              page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
              page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))
              if @report.participant_ids.size > 1
                page.show 'common-reasons-link'
              end
            end
          end
        }
      end
    end
  end
  
  def remove_participant
    @report = session[:report]
    @participant_id = Integer(params[:id])
    infractions = @report.contact_reasons_for(@participant_id)
    infractions.each do |ri|
      @report.report_participant_relationships.delete(ri)
      ri.destroy
    end
    @iphone_div_id = "p-in-report-#{@participant_id}"
    
    respond_to do |format|
      format.js
      format.iphone{
        render :update do |page|
          page.remove("#{@iphone_div_id}")
        end
      }
    end
  end
  
  def create_participant_and_add_to_report
    @participant = Participant.create
    @participant.first_name = params[:first_name]
    @participant.last_name = params[:last_name]
    @participant.middle_initial = params[:middle_initial]
    @participant.affiliation = params[:affiliation]

    if params[:ignore_dob].nil?
      @participant.birthday = Date.civil(params[:range][:"#{:birthday}(1i)"].to_i,params[:range][:"#{:birthday}(2i)"].to_i,params[:range][:"#{:birthday}(3i)"].to_i) rescue unknown_date
    end
    @participant.full_name = "#{@participant.first_name} #{@participant.middle_initial} #{@participant.last_name}"
    @participant.update_attributes(@participant)

    @report = session[:report]
    # This redirect presents a problem for https
    #redirect_to :action => 'add_participant', :full_name => @participant.full_name, :format => :js
    @report.add_default_contact_reason(@participant.id)
    respond_to do |format|
      format.js
      format.iphone {
        render :update do |page|
          if !@report.associated?(@participant)
            page.select("input#full_name").first.clear
            page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
            page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))
            if @report.participant_ids.size > 1
              page.show 'common-reasons-link'
            end
          end
        end
      }
    end
  end
  
  def forward_as_mail
    parties = params[:parties]
    parties.delete_if {|key, value| value != "1" }
    parties = InterestedParty.where(:id => parties.keys)
    emails = parties.collect { |p| p.email }
    # add "other" forwarding emails
    (emails  += params[:other].split(/[,|;|\s+]/).select { |e| e.size  > 0 }) if not params[:other].nil?
    @report = session[:report]
    
    begin
      RadarMailer.report_mail(@report, emails, current_staff).deliver
      InterestedPartyReport.log_forwards(@report, parties, emails, current_staff)
      msg = "Report #{@report.tag} was forwarded to "+ emails.join(",")
    rescue => e
      logger.debug(e.backtrace.join("\n"))
      msg = "Unable to deliver mail. #{$!}"
      logger.debug("Failed to send mail #{$!}")
    end
    respond_to do |format|
      format.js { render :locals => { :flash_notice => msg } }
    end
  end
  
  # Used only by iphone view
  def on_duty_index
    model_name = params[:controller].chomp('_controller').camelize.singularize
    shift_start_time = current_staff.current_shift.created_at
    @reports = Kernel.const_get(model_name).where("created_at > ? and staff_id = ? and type = ? ", shift_start_time, current_staff.id, model_name).order(:approach_time)

    respond_to do |format|
      format.iphone {render :file => "reports/on_duty_index", :layout => 'mobile_application'}
    end
  end
  
  def update_annotation
    text = params[:text]
    pid = params[:participant]
    reason = params[:reason]
    report = session[:report]
    if text.length == 0 or text == nil
        report.remove_annotation_for(pid, reason, text)
    else
        report.add_annotation_for(pid, reason, text)
    end
    respond_to do |format|
        format.js {render :nothing => true}
    end
  end
  
  def update_common_annotation
    text = params[:text]
    reason = params[:reason]
    report = session[:report]
    pids = report.participant_ids
    pids.each do |pid|
        if text.length == 0 or text == nil
            report.remove_annotation_for(pid, reason, text)
        else
            report.add_annotation_for(pid, reason, text)
        end
    end
    respond_to do |format|
        format.js {render :nothing => true}
    end
  end
  
  def update_duration
    text = params[:text]
    pid = params[:participant]
    reason = params[:reason]
    report = session[:report]
    time_string = text.split(" ")
    hours = time_string[0].to_i()
    min = time_string[2].to_i()
    minutes = (hours*60) + min
    report.add_duration_for(pid, reason, minutes)
    respond_to do |format|
        format.js {render :nothing => true}
    end
  end
  
  def update_common_duration
    text = params[:text]
    reason = params[:reason]
    report = session[:report]
    pids = report.participant_ids
    time_string = text.split(" ")
    hours = time_string[0].to_i()
    min = time_string[2].to_i()
    minutes = (hours*60) + min
    pids.each do |pid|
        report.add_duration_for(pid, reason, minutes)
    end
    respond_to do |format|
        format.js {render :nothing => true}
    end
  end
  
  def update_reason
    pid = params[:participant]
    id = params[:reason]
    reason = /\d+_(\d+)/.match(id)[1]
    checked = params[:checked]
    report = session[:report]
    checked.downcase == "true" ? report.add_contact_reason_for(pid, reason) : report.remove_contact_reason_for(pid,  reason)
    respond_to do |format|
      format.js { render_set_reason(id, checked, false)	}
      format.iphone { render_set_reason(id, checked, true) }
    end
  end
  
  def update_common_reasons
    report = session[:report]
    checked = params[:checked]
	
    participant_ids = report.participant_ids
    reasons = {}
	
    params.each do |key, value|
      if /common_reasons_(\d+)/.match(value) != nil
        logger.debug("update reason #{$1} to #{checked}")
        participant_ids.each do |pid|
          logger.debug("update reason for #{pid}")
          checked.downcase == "true" ? report.add_contact_reason_for(pid, $1) : report.remove_contact_reason_for(pid, $1)
        end
        reasons[$1] = checked
      end
    end
    logger.debug("reasons #{reasons}")
    respond_to do |format|
      format.js { render_common_reasons_update(participant_ids, reasons, false) }
      format.iphone { render_common_reasons_update(participant_ids, reasons, true) }
    end
  end
  
  def search_results
    @reports = Kernel.const_get(params[:type]).accessible_by(current_ability)
    report_ids = Array.new
    student = nil
    # if a student's name was entered, find all reports with that student
    if params[:full_name].length > 3 # arbitrary number
      # get the student for the string entered
      student = Participant.get_participant_for_full_name(params[:full_name])
=begin   
      # get all reported infractions for that student
      reported_inf = ReportParticipantRelationship.where(:participant_id => student.id)
          
      # get all of the report ids from the reported infractions
      reported_inf.each do |ri|
        report_ids << ri.report_id
      end
	   # get the incident reports with those ids
      @reports = @reports.where(:id => report_ids)
=end
          
       @reports = student.reports
    end
    
    #-----------------
    # if a particular infraction was selected, get all reports w/ that infraction
    if (params[:infraction_id] != nil)
      if !(params[:infraction_id].count == 1 && params[:infraction_id].include?("0"))
        # get reported infractions all with that infraction
        reported_inf = ReportParticipantRelationship.where(:relationship_to_report_id => params[:infraction_id])
			  
        # if a student was selected, limit to only those infractions by that student
        if student != nil
          reported_inf = reported_inf.where(:participant_id => student.id)
          report_ids = Array.new
        end
			  
        # collect the report_ids from the reported infractions into an array
        reported_inf.each do |ri|
          report_ids << ri.report_id
        end
			  
        # get the reports with ids in the array
        @reports = @reports.where(:id => report_ids)
      end
    end
        
    #----------------
    # if no student or infraction was selected, select all
    if @reports == nil
      @reports = @reports.where(:submitted => true)
    end
        
        
    #-----------------
    # if a building was selected, get reports in that building
    if param_value_present(params[:building_id]) 
      @reports = @reports.where(:building_id => params[:building_id])
    end
        
    #-----------------
    # if an area was selected, get reports in that area
    if param_value_present(params[:area_id]) and (not param_value_present(params[:building_id]))
      #buildings = Building.where(:area_id => params[:area_id])
      #@reports = @reports.where(:building_id => buildings) 
	  @reports = @reports.where(Area.find(params[:area_id]).buildings)
    end
        
    #-----------------
	
	max,min = Time.now.gmtime, Time.parse("01/01/1970").gmtime
	filter_by_datetime = false
    # if a date was provided, find all before that date
    if param_value_present(params[:submitted_before]) 
       max = convert_arg_datetime(born_before) rescue nil
       filter_by_datetime = true if !max.nil?   
    end
        
    #-----------------
    # if a date was provided, find all after that date
    if param_value_present(params[:submitted_after])
		min = convert_arg_datetime(born_after) rescue nil
        filter_by_datetime = true if !min.nil?
    end
	logger.debug("Using date filter #{filter_by_datetime} max = #{max} min = #{min} ")
	
	@reports = @reports.where(:approach_time => min..max) if filter_by_datetime
            
    # finishing touches...
    @reports = @reports.where(:submitted => true).paginate(:page => params[:page], :per_page => 30)
    params[:sort] ||= Report.default_sort_field
    @reports = Report.sort(@reports,params[:sort])
      
logger.debug("Search result #{@reports.size} reports")	  
    @num_reports = @reports.count
    report_type = ReportType.find_by_name(params[:type])
    respond_to do |format|
      format.js{ render :locals => { :report_type => report_type } }
    end
  end
  
  private
  def render_set_reason(id, checked, webapp_refresh)
    render :update do |page|
      checked.downcase == "true" ? page[id].set_attribute('checked', 'true') : page[id].remove_attribute('checked')
      page << "$('#{id}').checked = #{checked.downcase}"
      if (webapp_refresh)
        page << "WebApp.Refresh('#{pid}_#{reason}')"
      end
    end
  end
  def render_common_reasons_update(participant_ids, reasons, webapp_refresh)
    render :update do |page|
      participant_ids.each do |p|
        reasons.each do |reason, checked |
          id = "#{p}_#{reason}"
          checked.downcase == "true" ? page[id].set_attribute('checked', 'true') : page[id].remove_attribute('checked')
          checked.downcase == "true" ? page << "$('#{id}').checked = true" :
            page << "$('#{id}').checked = false"
        end
      end
      if (webapp_refresh)
        participant_ids.each do |p|
          reasons.each do |reason, checked |
            page << "WebApp.Refresh('#{p}_#{reason}');"
          end
        end
      end
    end
  end
end