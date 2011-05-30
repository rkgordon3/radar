class RoundsController < ApplicationController
  # GET /rounds
  # GET /rounds.xml
  
  before_filter :authenticate_staff!
  before_filter :ra_authorize_view_access 
  skip_before_filter :verify_authenticity_token
  
  def index
    @rounds = Round.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rounds }
    end
  end

  # GET /rounds/1
  # GET /rounds/1.xml
  def show
    @round = Round.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @round }
    end
  end

  # GET /rounds/new
  # GET /rounds/new.xml
  def new
    @round = Round.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @round }
    end
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  # POST /rounds.xml
  def create
    @round = Round.new(params[:round])

    respond_to do |format|
      if @round.save
        format.html { redirect_to(@round, :notice => 'Round was successfully created.') }
        format.xml  { render :xml => @round, :status => :created, :location => @round }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @round.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rounds/1
  # PUT /rounds/1.xml
  def update
    @round = Round.find(params[:id])

    respond_to do |format|
      if @round.update_attributes(params[:round])
        format.html { redirect_to(@round, :notice => 'Round was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @round.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.xml
  def destroy
    @round = Round.find(params[:id])
    @round.destroy

    respond_to do |format|
      format.html { redirect_to(rounds_url) }
      format.xml  { head :ok }
    end
  end
  
  def start_round
    # I NEED A SHIFT ID TO DO ANYTHINGGGG
    	@round = Round.new
	#shift = params[:shift_id]
	@shift = Shift.where(:staff_id => current_staff.id, :time_out => nil).first
	#logger.debug "current staff = #{current_staff.first_name}"
	logger.debug "shift = #{@shift.id}"
	@round.shift_id = @shift.id
	@round.save
		
	respond_to do |format|	
		format.js
		format.iphone {
			render :update do |page|
				page.replace_html("round_button", :partial=>"rounds/end_round_button")
			end
		}
	end
  end
  
  def end_round
  # add where shift time something
	@shift = Shift.where(:staff_id => current_staff.id, :time_out => nil).first
	@round = Round.where(:end_time => nil, :shift_id => @shift.id).first
	@round.end_time = Time.now
	@round.save
	respond_to do |format| 
		format.js
		format.iphone {
			render :update do |page|
				page.replace_html("round_button", :partial=>"rounds/start_round_button")
			end
		}
	end
  end
end
