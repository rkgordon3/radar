class RelationshipToReportsController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  # GET /infractions
  # GET /infractions.xml
  def index
    @numRows = 0

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @relationship_to_reports }
    end
  end

  # GET /infractions/1
  # GET /infractions/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @relationship_to_report }
    end
  end

  # GET /infractions/new
  # GET /infractions/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @relationship_to_report }
    end
  end

  # GET /infractions/1/edit
  def edit
    # @relationship_to_report automatically loaded by CanCan
  end

  # POST /infractions
  # POST /infractions.xml
  def create
    respond_to do |format|
      if @relationship_to_report.save
        format.html { redirect_to(@relationship_to_report, :notice => 'Relationship to report was successfully created.') }
        format.xml  { render :xml => @relationship_to_report, :status => :created, :location => @relationship_to_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @relationship_to_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /infractions/1
  # PUT /infractions/1.xml
  def update
    respond_to do |format|
      if @relationship_to_report.update_attributes(params[:relationship_to_report])
        format.html { redirect_to(@relationship_to_report, :notice => 'Relationship to report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @relationship_to_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /infractions/1
  # DELETE /infractions/1.xml
  def destroy
    @relationship_to_report.destroy

    respond_to do |format|
      format.html { redirect_to(relationship_to_reports_url) }
      format.xml  { head :ok }
    end
  end
end
