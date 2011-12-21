class ReportFieldsController < ApplicationController
  # GET /report_fields
  # GET /report_fields.xml
  def index
    @report_fields = ReportField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @report_fields }
    end
  end

  # GET /report_fields/1
  # GET /report_fields/1.xml
  def show
    @report_field = ReportField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report_field }
    end
  end

  # GET /report_fields/new
  # GET /report_fields/new.xml
  def new
    @report_field = ReportField.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report_field }
    end
  end

  # GET /report_fields/1/edit
  def edit
    @report_field = ReportField.find(params[:id])
  end

  # POST /report_fields
  # POST /report_fields.xml
  def create
    @report_field = ReportField.new(params[:report_field])

    respond_to do |format|
      if @report_field.save
        format.html { redirect_to(@report_field, :notice => 'Report field was successfully created.') }
        format.xml  { render :xml => @report_field, :status => :created, :location => @report_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /report_fields/1
  # PUT /report_fields/1.xml
  def update
    @report_field = ReportField.find(params[:id])

    respond_to do |format|
      if @report_field.update_attributes(params[:report_field])
        format.html { redirect_to(@report_field, :notice => 'Report field was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /report_fields/1
  # DELETE /report_fields/1.xml
  def destroy
    @report_field = ReportField.find(params[:id])
    @report_field.destroy

    respond_to do |format|
      format.html { redirect_to(report_fields_url) }
      format.xml  { head :ok }
    end
  end
end
