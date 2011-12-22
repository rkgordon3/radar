class ParticipantsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  autocomplete :participant, :full_name, :display_value => :full_name, :full => true
  
  def index
    @numRows = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @participants }
    end
  end

  # GET /participants/1
  # GET /participants/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participants/new
  # GET /participants/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @participant }
    end
  end

  # GET /participants/1/edit
  def edit
    # @participant automatically loaded by CanCan
  end

  # POST /participants
  # POST /participants.xml
  def create
    respond_to do |format|
      if @participant.save
        format.html { redirect_to(@participant, :notice => 'Participant was successfully created.') }
        format.xml  { render :xml => @participant, :status => :created, :location => @participant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /participants/1
  # PUT /participants/1.xml
  def update
    respond_to do |format|
      if @participant.update_attributes(params[:participant])
        format.html { redirect_to(@participant, :notice => 'Participant was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @participant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.xml
  def destroy
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to(participants_url) }
      format.xml  { head :ok }
    end
  end
  
  def search_results
  	@participants = []

    @participants << Participant.find(params[:participant][:id]) if param_value_present(params[:participant][:id]) 
    if @participants.empty?
      @participants = Participant.where("lower(full_name) like ?", "%#{params[:full_name].downcase}%") if (param_value_present(params[:full_name]) && @participants.empty?)
    
      @participants = Participant.where("student_id like ?", "%#{params[:student_id]}%") if (param_value_present(params[:student_id]) && @participants.empty?)

      #----------------
      # if no student was selected, select all
    
      #@participants = Participant.where(:type => "Student") if @participants.empty?
    
      #-----------------
      # if a building was selected, get students in that building

      if param_value_present(params[:building_id])
        @participants = @participants.where(:building_id => params[:building_id]) rescue Participant.where(:building_id => params[:building_id])
        
        #-----------------
        # if a building was selected, get students in that building
       
        if param_value_present(params[:room_number])
          @participants = @participants.where(:room_number => params[:room_number])
        end
      end
      
      #logger.debug("****************Area = #{params[:area_id]} Building = #{params[:building_id]}")
      
      #-----------------
      # if an area was selected, get students in that area
      if param_value_present(params[:area_id]) && (not param_value_present(params[:building_id]))
        buildings = Building.where(:area_id => params[:area_id])
        @participants = @participants.where(:building_id => buildings)
        
      end

      if param_value_present(params[:participant])
        #-----------------
        # if a date was provided, find all before that date
        born_before = params[:participant][:born_before]
	      max,min = Time.now.gmtime, Time.parse("01/01/1970").gmtime
        filter_by_date = false
		  
        if param_value_present(born_before)
          max = convert_arg_date(born_before) rescue nil
          filter_by_date = true if !max.nil?
        end

		  
        #-----------------
        # if a date was provided, find all after that date
        born_after = params[:participant][:born_after]

        if  param_value_present(born_after)
          dd,mm,yy = $1, $2, $3 if born_after =~ /(\d{2})-([A-Z|a-z]{3})-(\d{4})/
          min = convert_arg_date(born_after) rescue nil
          filter_by_date = true if !min.nil?
        end
        @participants = @participants.where(:birthday => min..max ) if filter_by_date
      end
      @participants = @participants.order(:last_name)
    end
    
    @num_results = @participants.count
    
    respond_to do |format|
      format.html
      format.iphone  { render  :layout => 'mobile_application' }
    end
  end

  def sort
    @participants = Participant.where(:id => params[:participants])
    sort = params[:sort]
    if sort == "First Name"
      @participants = @participants.order("first_name ASC")
    elsif sort == "Last Name"
      @participants = @participants.order("last_name ASC")
    elsif sort == "Middle Initial"
      @participants = @participants.order("middle_initial ASC")
    elsif sort == "Student ID"
      @participants = @participants.order("student_id ASC")
    elsif sort == "Building"
      @participants = @participants.joins(:building).order("buildings.name ASC")
    elsif sort == "Room #"
      @participants = @participants.order("room_number ASC")
    elsif sort == "Extension"
      @participants = @participants.order("extension ASC")
    elsif sort == "Email"
      @participants = @participants.order("email ASC")
    elsif sort == "Birthday"
      @participants = @participants.order("birthday ASC")
    end
    msg = "Results are now sorted by #{sort}."
    respond_to do |format|
      format.js { render :locals => { :flash_notice => msg }}
    end
  end
  
  
end
