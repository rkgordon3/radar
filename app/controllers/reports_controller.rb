class ReportsController < ApplicationController

  REASON_ID_INDEX_IN_REASON_PARAM  = 3
  REASON_ID_INDEX_IN_COMMON_REASON_PARAM = 2

  
  include ReportsHelper

  before_filter :authenticate_staff!
  # This is a kludge to prevent controller form interpreting
  # id in remove_participant url as a report id
  load_resource :except => :remove_participant
  authorize_resource

 

  rescue_from Errno::ECONNREFUSED, :with => :display_error
  
  # if params[:report][:id] contains a report id, use that report, otherwise
  # use report in the sesson, i.e. a new report 
  def active_report
   (Report.find(params[:report][:id]) rescue nil) ||  (Report.find(session[:report]) rescue nil)
  end
  
  def index
	@reports = nil

    params[:paginate] ||= '1'
    params[:paginate] = params[:paginate].to_i
	

	report_type = param_value_present(params[:report_type]) ? params[:report_type] : current_staff.preference(:report_type)

	# search_results places 'referrer' param in request before redirect
	# Conversely, 'list' reports contains only a report_type, so if :referrer
	# not present and there is no reports from previous result, generate generic list
    if (params[:reports].nil?) and (not param_value_present(params[:referrer]))
	  @reports = Kernel.const_get(report_type).accessible_by(current_ability).preferred_order(current_staff)
	else
      #reports were passed to index through js by sort links or search results
      all_reports = params[:reports]
      sort = params[:sort]
      @reports = Report.sort_by(current_staff, sort).where(:id => params[:reports]).accessible_by(current_ability)
      msg = "Reports are now sorted by #{sort}." if not sort.nil?
    end

    all_reports = @reports.collect{|r| r.id}
    @reports = @reports.paginate(:page => params[:page], :per_page => INDEX_PAGE_SIZE) if params[:paginate] > 0
	

    respond_to do |format|
      format.html { render :locals => { :reports => @reports, :report_type=> report_type, :all_reports => all_reports, :paginate => 1 } }
      format.xml  { render :xml => @reports }
      format.js { render :locals => { :flash_notice => msg, :div_id => params[:div_id], :report_type => report_type, :all_reports => all_reports, :paginate => params[:paginate] }}
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])
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
    report_name =  params[:report_type] || ReportType.find(params[:report_type_id].to_i).name
    @report = report_name.constantize.new(:staff_id => current_staff.id)
    session[:report] = @report
    unless params[:participants].nil?
	  new_participants = params[:participants].collect { |id| Participant.find(id) }
      @report.add_participants(new_participants)
    end
    respond_to do |format|
      format.html { render 'reports/new' }
      format.iphone { render "reports/new", :layout => 'mobile_application' }
    end
  end
  
  
  # GET /reports/new
  # GET /reports/new.xml
  def new
    # experiment
    @report.save
    #end experiment
    session[:report] = @report.id

    respond_to do |format|
      format.html { render "reports/new" }
      format.iphone { render "reports/new", :layout => 'mobile_application' }
    end
  end
  
  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])

    @report_adjuncts = ReportAdjunct.find_all_by_report_id(@report.id)

    respond_to do |format|
      format.html { render 'reports/edit' }
      format.iphone { render "reports/edit", :layout => 'mobile_application' }
    end
  end
  
  # POST /reports
  # POST /reports.xml
  def create
    #@report = session[:report]
    params[:report][:annotation] = Annotation.new(text: params[:report][:annotation]) if not params[:report][:annotation].blank?
	  @report = Report.new(params[:report])
    params[:report][:report_adjuncts] = params[:report_adjuncts]
    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        format.html { redirect_to home_landingpage_path, :flash_notice => 'Report was successfully created.' }
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
    @report =  Report.find(params[:id])
    params[:report][:report_adjuncts] = params[:report_adjuncts]

    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        format.html { redirect_to home_landingpage_path, :flash_notice => 'Report was successfully updated.' }
        format.xml  { head :ok }
        format.iphone { redirect_to(home_landingpage_path, :notice => "Report updated" ) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    
    respond_to do |format|
      format.js 
      format.xml  { head :ok }
    end
  end
  
  def add_participant
    @report = active_report
    @report = params[:report][:type].constantize.new if @report.nil?
    
    @participant = Participant.find(params[:participant][:id]) if param_value_present(params[:participant][:id])
   
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
            page.show 'common-reasons-container' if display_common_reasons?(@report)
          end
        }
      end
    else
      @insert_new_participant_partial = !@report.associated?(@participant)
      #@insert_new_participant_partial = true
      @report.add_default_contact_reason(@participant) unless @report.associated?(@participant)
      respond_to do |format|
        format.js
        format.iphone {
          render :update do |page|
            if @insert_new_participant_partial
             # @report.add_default_contact_reason(@participant) unless @report.associated?(@participant)
              page.select("input#full_name").first.clear
              page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
              page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))
              page.show 'common-reasons-link' if display_common_reasons?(@report)

            end
          end
        }
      end
    end
  end
  
  def remove_participant
    @report = active_report
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
    @report = active_report
    
	@participant = Participant.create
    @participant.first_name = params[:first_name]
    @participant.last_name = params[:last_name]
    @participant.middle_initial = params[:middle_initial]
    @participant.affiliation = params[:affiliation]

    @participant.birthday = convert_arg_date(params[:birthday])  if params[:ignore_dob].nil?
    @participant.full_name = "#{@participant.first_name} #{@participant.middle_initial} #{@participant.last_name}"
    @participant.update_attributes(@participant)

    @report.add_default_contact_reason(@participant)
    respond_to do |format|
      format.js
      format.iphone {
        render :update do |page|
          if !@report.associated?(@participant)
            page.select("input#full_name").first.clear
            page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
            page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))
            page.show 'common-reasons-link' if display_common_reasons?(@report)
          end
        end
      }
    end
  end
  
  def forward_as_mail
    @report = Report.find(params[:id])
    parties = InterestedParty.where(:id => params[:parties].keys)
    emails = parties.collect { |p| p.email }
    # add "other" forwarding emails
    (emails  += params[:other].split(/[,|;|\s+]/).select { |e| e.size  > 0 }) if not params[:other].nil?
   
    begin
      RadarMailer.report_mail(@report, emails, current_staff).deliver
      InterestedPartyReport.log_forwards(@report, parties, emails, current_staff)
      msg = "Report #{@report.tag} was forwarded to "+ emails.join(",")
    rescue => e
      logger.info(e.backtrace.join("\n"))
      msg = "Unable to deliver mail. #{$!}"
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
	active_report.update_annotations([ params[:participant] ], params[:reason], params[:text]) 
    respond_to do |format|
      format.js {render :nothing => true}
    end
  end
  
  def update_common_annotation
	active_report.update_annotations(nil, params[:reason], params[:text])
    respond_to do |format|
      format.js  { render :locals => { :report => active_report, :reason_id => params[:reason], :text => params[:text] } }
    end
  end
 
  def update_duration
    active_report.update_durations([params[:participant]], params[:reason],  ReportParticipantRelationship.parse_duration(params[:text]))
    respond_to do |format|
      format.js {render :nothing => true}
    end
  end
  
  def update_common_duration
    active_report.update_durations(nil, params[:reason], ReportParticipantRelationship.parse_duration(params[:text]))
    respond_to do |format|
      format.js  { render :locals => { :report => active_report, :reason_id => params[:reason], :time => params[:text] } }
    end
  end
  
  def update_reason
	report = active_report
    pid = params[:participant].to_i
    checked = params[:checked]
    reason_id = params[:reason].split("_")[REASON_ID_INDEX_IN_REASON_PARAM]
	
    checked.downcase == "true" ? report.add_contact_reason_for(pid, reason_id) : report.remove_contact_reason_for(pid,  reason_id)
    respond_to do |format|
      format.js { render_common_reasons_update(report, [pid], [reason_id],  checked, false)	}
      format.iphone { render_common_reasons_update(report, [pid], [reason_id], checked, true) }
    end
  end
  
  def update_common_reasons
    report = active_report
    checked = params[:checked]
	
    participant_ids = report.participant_ids
    reason_id = params[:reason].split("_")[REASON_ID_INDEX_IN_COMMON_REASON_PARAM]

    participant_ids.each do |pid|
        checked.downcase == "true" ? report.add_contact_reason_for(pid, reason_id) : report.remove_contact_reason_for(pid, reason_id)
    end

    respond_to do |format|
      format.js { render_common_reasons_update(report, participant_ids, [reason_id], checked, false) }
      format.iphone { render_common_reasons_update(report, participant_ids, [reason_id], checked, true) }
    end
  end
  
  def search_results
    group_fields = %{reports.id,reports.created_at,reports.updated_at,reports.building_id,reports.approach_time,reports.room_number,reports.type, reports.staff_id, reports.submitted, reports.annotation_id, reports.tag, reports.organization_id}
    @reports = Report.accessible_by(current_ability)
    # Select for student id if present
    @reports = @reports.joins(:participants).where(:participants => { :id => params[:participant][:id]}).group(group_fields) if param_value_present(params[:participant][:id])
    # Select for type if present
    @reports = @reports.where(:type => params[:type]) if param_value_present(params[:type])
	
    # Select for reasons
    if param_value_present(params[:infraction_id])
      # Clean up params[:infraction_id] array. There are null strings from browser
      # Not going to figure it out now.
      params[:infraction_id].select! { |id| id.length > 0 }
      # The clunky group() invocation is [rightfully] imposed by Oracle. Any fields appearing in select
      # but NOT appearing in an aggregate (in this case there is none) must appear in group by. The previous
      # implementation, group(:id) caused Oracle to complain, again, rightfully, about ambiguous field. It did
      # not know from which table the :id was to be 'grouped'.
      @reports = @reports.joins(:report_participant_relationships)
      .where(:report_participants => {:relationship_to_report_id => params[:infraction_id]})
      .group(group_fields) if params[:infraction_id].length > 0
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
	
    @reports = @reports.where(:approach_time => min..max) if filter_by_datetime

    # finishing touches...
    all_reports = @reports.collect{|r| r.id}
    @reports = @reports.preferred_order(current_staff).paginate(:page => params[:page], :per_page => INDEX_PAGE_SIZE)

    respond_to do |format|
      format.js { redirect_to({ :protocol => Rails.env.production? ? "https://" : "http://", 
			       :action => "index",
                               :div_id => 'results', 
                               :referrer => "search", 
                               :reports => all_reports, 
                               :page => params[:page] })}
    end
  end
  
  private
  
    # Return minutes


  def render_set_reason(id, checked, webapp_refresh)
    render :update do |page|
      checked.downcase == "true" ? page[id].set_attribute('checked', 'true') : page[id].remove_attribute('checked')
      page << "$('#{id}').checked = #{checked.downcase}"
=begin
      if (webapp_refresh)
        page << "WebApp.Refresh('#{pid}_#{reason}')"
      end
=end
    end
  end
  def render_common_reasons_update(report, participant_ids, reason_ids, checked, webapp_refresh)
    render :update do |page|
      participant_ids.each do |pid|
        reason_ids.each do |reason_id |
          id = "report_reason_#{pid}_#{reason_id}"
		  detail_id = "#{pid}_#{reason_id}_details"
          checked.downcase == "true" ? page[id].set_attribute('checked', 'true') : page[id].remove_attribute('checked')
          page << "$('#{id}').checked = #{checked.downcase}"
		  page.show(detail_id) if report.supports_contact_reason_details?
        end
      end
=begin	  
      if (webapp_refresh)
        participant_ids.each do |pid|
          reasons_ids.each do |reason_id |
		    id = "reason_#{pid}_#{reason_id}"
            page << "WebApp.Refresh('#{id}');"
          end
        end
      end
=end
    end
  end
end
