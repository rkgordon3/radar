class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
  before_filter :authenticate_staff!
  before_filter :ra_authorize_view_access
  
  
  def index
    @reports = Report.where(:submitted => true, :approach_time => Time.now - 30.days .. Time.now, :type => params[:report])
    @report_type = params[:report]
    params[:sort] ||= "approach_time"
    logger.debug params[:sort]
    @reports = Report.sort(@reports,params[:sort]).paginate(:per_page => 30, :page => params[:id])
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
      format.js
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])
    if params[:emails] != nil
      forward_as_mail(params[:emails])
      return
    end
    
    # get the interested parties to email for this report type
    @interested_parties = InterestedParty.where(:report_type_id=>@report.type_id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
      format.iphone {render :layout => 'mobile_application'}
    end
  end
  
  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new(:staff_id =>  current_staff.id )
    session[:report] = @report
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
      format.iphone { render :layout => 'mobile_application' }
    end
  end
  
  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
    session[:report]=@report
  end
  
  # POST /reports
  # POST /reports.xml
  def create
    logger.debug("IN REPORT CREATE params: #{params}")
    
    @report = session[:report]
    logger.debug("IN REPORT CREATE report:  #{@report}")
    
    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        format.html { redirect_to(@report, :notice => 'Report was successfully created.') }
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
    logger.debug("Report update")
    @report = Report.find(params[:id])
    
    respond_to do |format|
      if @report.update_attributes_and_save(params[:report])
        format.html { redirect_to(@report, :notice => 'Report was successfully updated.') }
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
    @report = Report.find(params[:id])
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
      firstName = name_tokens[0].capitalize
      lastName = name_tokens[2].capitalize
      middleInitial = name_tokens[1].capitalize
      
      respond_to do |format|
        format.js{
          render :update do |page|
            page.select("input#full_name").first.clear
            page.replace_html("new-part-div", :partial => "participants/new_participant_partial", :locals => { :fName => firstName, :mInitial => middleInitial, :lName => lastName })
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
            end
          end
        }
      end 
    end
    @report.add_default_relationship_for_participant(@participant.id)
  end
  
  def remove_participant
    logger.debug "In remove method #{params}"
    @report = session[:report]
    @participant_id = Integer(params[:id])
    infractions = @report.get_report_participant_relationships_for_participant(@participant_id)
    logger.debug "ID: #{@participant_id} reported infractions: #{infractions}"
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
    logger.debug "Parameters = #{params}"
    @participant.first_name = params[:first_name]
    @participant.last_name = params[:last_name]
    @participant.middle_initial = params[:middle_initial]
    @participant.affiliation = params[:affiliation]
    @participant.birthday = Date.civil(params[:range][:"#{:birthday}(1i)"].to_i,params[:range][:"#{:birthday}(2i)"].to_i,params[:range][:"#{:birthday}(3i)"].to_i)
    @participant.full_name = "#{@participant.first_name} #{@participant.middle_initial} #{@participant.last_name}"
    @participant.update_attributes(@participant)
    redirect_to :action => 'add_participant', :full_name => @participant.full_name, :format => :js
  end
  
  def forward_as_mail(emails)
    emails.delete_if {|key, value| value != "1" }
    mail = RadarMailer.report_mail(@report, emails.keys, current_staff)
    
    begin
      mail.deliver
    rescue 
    end
    
    respond_to do |format|
      format.html { redirect_to(@report, :notice => "Report was forwarded to " + emails.keys.join(", ") + ".") }
    end  
  end
  
  # Used only by iphone view
  def on_duty_index
    model_name = params[:controller].chomp('_controller').camelize.singularize
    shift_start_time = current_staff.current_shift.created_at
    @reports = Kernel.const_get(model_name).where("created_at > '#{shift_start_time}' and staff_id = ? and type = '#{model_name}' ",  current_staff.id).order(:approach_time)
    
    respond_to do |format|
      format.iphone {render :file => "reports/on_duty_index", :layout => 'mobile_application'}
    end
  end
  
  def index_search
    @reports = nil
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
      @reports = Report.where(:id => report_ids, :type => params[:type])
    end
    
    #-----------------
    # if a particular infraction was selected, get all reports w/ that infraction
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
      @reports = Report.where(:id => report_ids, :type => params[:type])
    end
    
    #----------------
    # if no student or infraction was selected, select all 
    if @reports == nil
      @reports = Report.where(:submitted => true, :type => params[:type])
    end
    
    
    #-----------------
    # if a building was selected, get reports in that building
    if Integer(params[:building_id]) != Building.unspecified 
      @reports = @reports.where(:building_id => params[:building_id])
    end
    
    #-----------------
    # if an area was selected, get reports in that area
    if Integer(params[:area_id]) != Area.unspecified 
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
      
      @reports = @reports.where(:approach_time => min..max )
    end
    
    #-----------------
    # if a date was provided, find all after that date
    if params[:submitted_after] != "" 
      # all incident reports should take place before right now (ignoring daylight savings)
      # be careful of time zones - all need to be in GMT to match the DB
      min = Time.parse(params[:submitted_after]).gmtime
      max = Time.now.gmtime
      
      @reports = @reports.where(:approach_time => min..max )
    end
    
    
    # finishing touches...
    @reports = @reports.where(:submitted => true)
    params[:sort] ||= "approach_time"
    @reports = Report.sort(@reports,params[:sort]).paginate(:per_page => 30, :page => params[:id])
    
    @num_reports = @reports.count
    respond_to do |format|
        format.js
    end
  end  
end
