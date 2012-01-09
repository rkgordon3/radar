class ReportsController < ApplicationController

include ReportsHelper

  before_filter :authenticate_staff!
  # This is a kludge to prevent controller form interpreting
  # id in remove_participant url as a report id
  load_resource :except => :remove_participant
  authorize_resource

  rescue_from Errno::ECONNREFUSED, :with => :display_error
  
  def index
    if (params[:report].nil?) 
      params[:report] = "Report"
    end
    @reports = Kernel.const_get(params[:report]).accessible_by(current_ability).paginate(:page => params[:page], :per_page => 30)
    report_type = ReportType.find_by_name(params[:report])
	  
    params[:sort] ||= Report.default_sort_field
    
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
      
      middle_initial = name_tokens[1].capitalize if (name_tokens.length > 2)
      last_name = name_tokens[name_tokens.length-1].capitalize
      
      respond_to do |format|
        format.js{
          render :update do |page|
            page.select("input#full_name").first.clear
            page.replace_html "new-part-div", 
			       :partial => "participants/new_participant_partial", 
				   :locals => { :fName => first_name, :mInitial => middle_initial, :lName => last_name }
			
            if @report.participant_ids.size > 1
              page.show 'common-reasons-container'
            end
          end
        }
      end
    else
      @insert_new_participant_partial = !@report.associated?(@participant)
      @report.add_default_contact_reason(@participant.id) unless @report.associated?(@participant)
      respond_to do |format|
        format.js 
        format.iphone {
          render :update do |page|
            if @insert_new_participant_partial
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
    @participant_id = params[:id]
	@report.remove_participant(@participant_id)

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

    @participant.birthday = convert_arg_date(params[:birthday])  if params[:ignore_dob].nil?
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
    respond_to do |format|
      format.js { render_common_reasons_update(participant_ids, reasons, false) }
      format.iphone { render_common_reasons_update(participant_ids, reasons, true) }
    end
  end
  
  def search_results
    @reports = Report.accessible_by(current_ability)
    # Select for student id if present
    @reports = @reports.joins(:participants).where(:participants => { :id => params[:participant][:id]}).group(:id) if param_value_present(params[:participant][:id])
    # Select for type if present
	@reports = @reports.where(:type => params[:type]) if param_value_present(params[:type]) 
	
	# Select for reasons
	# Clean up params[:infraction_id] array. There are null strings from browser
	# Not going to figure it out now.
	if param_value_present(params[:infraction_id])
	  params[:infraction_id].select! { |id| id.length > 0 }
	  @reports = @reports.joins(:report_participant_relationships)
	                     .where(:report_participants => {:relationship_to_report_id => params[:infraction_id]})
						 .group(:id) if params[:infraction_id].length > 0
	end
	
	# Select for building if present   
    @reports = @reports.where(:building_id => params[:building_id]) if param_value_present(params[:building_id]) 
	# Select for area, if present and building not selected
	@reports = @reports.where(Area.find(params[:area_id]).buildings) if param_value_present(params[:area_id]) and (not param_value_present(params[:building_id]))
	
	max,min = Time.now.gmtime, Time.parse("01/01/1970").gmtime
	filter_by_datetime = false
    # if a date was provided, find all before that date
    if param_value_present(params[:submitted_before]) 
       max = convert_arg_datetime(params[:submitted_before]) rescue nil
       filter_by_datetime = true if !max.nil?   
    end
        
    #-----------------
    # if a date was provided, find all after that date
    if param_value_present(params[:submitted_after])
		min = convert_arg_datetime(params[:submitted_after]) rescue nil
        filter_by_datetime = true if !min.nil?
    end
	logger.debug("Using date filter #{filter_by_datetime} max = #{max} min = #{min} ")
	
	@reports = @reports.where(:approach_time => min..max) if filter_by_datetime
         
    # finishing touches...
    @reports = @reports.paginate(:page => params[:page], :per_page => 30)    
    @reports = Report.sort(@reports,params[:sort] ||= Report.default_sort_field)
       
    @num_reports = @reports.length

    respond_to do |format|	  
        format.js 
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