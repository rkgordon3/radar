class RoundsController < ApplicationController
  before_filter :authenticate_staff!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rounds }
    end
  end

  # GET /rounds/1
  # GET /rounds/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @round }
    end
  end

  # GET /rounds/new
  # GET /rounds/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @round }
    end
  end

  # GET /rounds/1/edit
  def edit
    # @round automatically loaded by CanCan
  end

  # POST /rounds
  # POST /rounds.xml
  def create
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
    @round.destroy

    respond_to do |format|
      format.html { redirect_to(rounds_url) }
      format.xml  { head :ok }
    end
  end
  
  def start_round
    shift = current_staff.current_shift
    if shift != nil && current_staff.current_round == nil #staff is on duty but not on a round
      @round = Round.new
      @round.shift_id = shift.id
      @round.save
    end
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
    shift = current_staff.current_shift
    @round = current_staff.current_round
    if shift != nil && @round != nil #staff is on duty and on a round
      @round.end_time = Time.now
      @round.save
    end
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
