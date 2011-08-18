class ReportsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  def index
    @reports = Kernel.const_get(params[:report]).accessible_by(current_ability).paginate(:page => params[:page], :per_page => 30)
    @report_type = ReportType.find_by_name(params[:report])
	  
    params[:sort] ||= "approach_time"
    
    @reports = Report.sort(@reports,params[:sort])
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.js
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    if params[:emails] != nil
      forward_as_mail(params[:emails])
      return
    end
	# add entry to view log if one does not exist for this staff/report combination
    current_staff.has_seen?(@report) || ReportViewLog.create(:staff_id => current_staff.id, :report_id=> @report.id)
    # get the interested parties to email for this report type
    @interested_parties = InterestedParty.where(:report_type_id=>@report.type_id)
    
    respond_to do |format|
      format.html { render 'reports/show' }
      format.iphone { render 'reports/show', :layout => 'mobile_application' }
    end
  end
  
  # GET /reports/new
  # GET /reports/new.xml
  def new
	session[:report] = @report
    if (params[:participants] != nil)
    	@report.add_participants(params[:participants])
    end
      
    respond_to do |format|
      format.html { render "reports/new" }
      format.iphone { render "reports/new", :layout => 'mobile_application' }
    end
  end
  
  # GET /reports/1/edit
  def edit
    session[:report]=@report

    respond_to do |format|
      format.html { render 'reports/edit' }
      format.iphone { render "reports/edit", :layout => 'mobile_application' }
    end
  end
  
  # POST /reports
  # POST /reports.xml
  def create
    @report = session[:report]
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
    @participant = Participant.get_participant_for_full_name(params[:full_name])
    @report = session[:report]
    
    if @participant == nil
	
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
			
            if @report.participant_ids.size > 0
              page.show 'common-reasons-container'
            end
          end
        }
      end
    else
      respond_to do |format|
        format.js
        format.iphone {
          render :update do |page|
            if !@report.associated?(@participant)
              page.select("input#full_name").first.clear
              page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
              page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))
              if @report.participant_ids.size > 0
                page.show 'common-reasons-link'
              end
            end
          end
        }
      end
      @report.add_default_contact_reason(@participant.id)
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
    @divid = "p-in-report-#{@participant_id}"
    
    respond_to do |format|
      format.js
      format.iphone{
        render :update do |page|
          page.remove("#{@divid}")
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
    @participant.birthday = Date.civil(params[:range][:"#{:birthday}(1i)"].to_i,params[:range][:"#{:birthday}(2i)"].to_i,params[:range][:"#{:birthday}(3i)"].to_i)
    @participant.full_name = "#{@participant.first_name} #{@participant.middle_initial} #{@participant.last_name}"
    @participant.update_attributes(@participant)
    redirect_to :action => 'add_participant', :full_name => @participant.full_name, :format => :js
  end
  
  def forward_as_mail
    emails = params[:emails]
    emails.delete_if {|key, value| value != "1" }
    emails_for_notice = emails.keys.join(", ")
    emails = emails.keys.join(", ")
    emails_for_notice.gsub!("<","(")
    emails_for_notice.gsub!(">",")")
    mail = RadarMailer.report_mail(Report.find(params[:report]), emails, current_staff)
    
    begin
      mail.deliver
    rescue
    end
   
    respond_to do |format|
      format.js { render :locals => { :emails => emails, :emails_for_notice => emails_for_notice } }
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
  
  def index_search
    @reports = Kernel.const_get(params[:type]).accessible_by(current_ability)
    report_ids = Array.new
    student = nil
    # if a student's name was entered, find all reports with that student
    if params[:full_name].length > 3 # arbitrary number
      # get the student for the string entered
      student = Participant.get_participant_for_full_name(params[:full_name])
          
      # get all reported infractions for that student
      reported_inf = ReportParticipantRelationship.where(:participant_id => student.id)
          
      # get all of the report ids from the reported infractions
      reported_inf.each do |ri|
        report_ids << ri.report_id
      end
          
      # get the incident reports with those ids
      @reports = @reports.where(:id => report_ids)
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
    if Integer(params[:building_id]) != Building.unspecified_id
      @reports = @reports.where(:building_id => params[:building_id])
    end
        
    #-----------------
    # if an area was selected, get reports in that area
    if Integer(params[:area_id]) != Area.unspecified_id
      buildings = Building.where(:area_id => params[:area_id])
      @reports = @reports.where(:building_id => buildings)
          
    end
        
    #-----------------
    # if a date was provided, find all before that date
    if params[:submitted_before] != ""
      # all incident reports should take place in this century
      # be careful of time zones - all need to be in GMT to match the DB
      min = Time.parse("01/01/2000").gmtime
      max = Time.parse(params[:submitted_before]).gmtime
          
      @reports = @reports.where(:approach_time => min..max)
    end
        
    #-----------------
    # if a date was provided, find all after that date
    if params[:submitted_after] != ""
      # all incident reports should take place before right now (ignoring daylight savings)
      # be careful of time zones - all need to be in GMT to match the DB
      min = Time.parse(params[:submitted_after]).gmtime
      max = Time.now.gmtime
          
      @reports = @reports.where(:approach_time => min..max)
    end
        
        
    # finishing touches...
    @reports = @reports.where(:submitted => true).paginate(:page => params[:page], :per_page => 30)
    params[:sort] ||= "approach_time"
    @reports = Report.sort(@reports,params[:sort])
        
    @num_reports = @reports.count
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