class ReportTypesController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource
  
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_types }
    end
  end

  # GET /report_types/1
  # GET /report_types/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_type }
    end
  end

  # GET /report_types/new
  # GET /report_types/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_type }
    end
  end

  # GET /report_types/1/edit
  def edit
    # @report_type automatically loaded by CanCan
  end

  # POST /report_types
  # POST /report_types.xml
  def create
    respond_to do |format|
      if @report_type.save
        format.html { redirect_to(@report_type, :notice => 'Report type was successfully created.') }
        format.xml  { render :xml => @report_type, :status => :created, :location => @report_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_types/1
  # PUT /report_types/1.xml
  def update
    respond_to do |format|
      if @report_type.update_attributes(params[:report_type])
        format.html { redirect_to(@report_type, :notice => 'Report type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_types/1
  # DELETE /report_types/1.xml
  def destroy
    @report_type.destroy

    respond_to do |format|
      format.html { redirect_to(report_types_url) }
      format.xml  { head :ok }
    end
  end
end
