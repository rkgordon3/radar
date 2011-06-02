class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
  before_filter :authenticate_staff!
  before_filter :ra_authorize_view_access
  
  
  def index
    @reports=Report.sort(Report,params[:sort])
    
    @numRows = 0
    
    respond_to do |format|
      format.html { render :locals => { :reports => @reports } }
      format.xml  { render :xml => @reports }
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])
    
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
    logger.debug("IN REPORT CREATE params #{params}")
    
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
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_participant
    @participant = Participant.get_participant_for_full_name(params[:full_name])
    @report = session[:report]
    logger.debug "Participant = #{@participant}"
    logger.debug "Report = #{@report}"
    if @participant == nil
      name_tokens = params[:full_name].split(' ')
      firstName = name_tokens[0].capitalize
      lastName = name_tokens[1].capitalize
      respond_to do |format|
        format.js{
          render :update do |page|
            page.select("input#full_name").first.clear
            page.replace_html("new-part-div", :partial => "participants/new_participant_partial", :locals => { :fName => firstName, :mInitial => middleInitial, :lName => lastName })
          end
        }
      end
    else
      @report.add_default_relationship_for_participant(@participant.id)
      respond_to do |format|
        format.js
        format.iphone {
          render :update do |page|
            page.select("input#full_name").first.clear
            page.insert_html(:top, "s-i-form", render( :partial => "reports/participant_in_report", :locals => { :report => @report, :participant => @participant }))
            page.insert_html(:top, "s-i-checkbox", render( :partial => "reports/report_participant_relationship_checklist", :locals => { :report => @report, :participant => @participant }))  
          end
        }
      end 
    end
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
    logger.debug "Partipant birthday = #{@participant.birthday}"
    logger.debug "ID = #{@participant.id}"
    redirect_to :action => 'add_participant', :full_name => @participant.full_name, :format => :js
  end
  
end
