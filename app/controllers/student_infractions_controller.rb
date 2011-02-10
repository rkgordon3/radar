class StudentInfractionsController < ApplicationController
  # GET /student_infractions
  # GET /student_infractions.xml
  def index
    @student_infractions = StudentInfraction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_infractions }
    end
  end

  # GET /student_infractions/1
  # GET /student_infractions/1.xml
  def show
    @student_infraction = StudentInfraction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_infraction }
    end
  end

  # GET /student_infractions/new
  # GET /student_infractions/new.xml
  def new
    @student_infraction = StudentInfraction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_infraction }
    end
  end

  # GET /student_infractions/1/edit
  def edit
    @student_infraction = StudentInfraction.find(params[:id])
  end

  # POST /student_infractions
  # POST /student_infractions.xml
  def create
    @student_infraction = StudentInfraction.new(params[:student_infraction])

    respond_to do |format|
      if @student_infraction.save
        format.html { redirect_to(@student_infraction, :notice => 'Student infraction was successfully created.') }
        format.xml  { render :xml => @student_infraction, :status => :created, :location => @student_infraction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_infraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_infractions/1
  # PUT /student_infractions/1.xml
  def update
    @student_infraction = StudentInfraction.find(params[:id])

    respond_to do |format|
      if @student_infraction.update_attributes(params[:student_infraction])
        format.html { redirect_to(@student_infraction, :notice => 'Student infraction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_infraction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_infractions/1
  # DELETE /student_infractions/1.xml
  def destroy
    @student_infraction = StudentInfraction.find(params[:id])
    @student_infraction.destroy

    respond_to do |format|
      format.html { redirect_to(student_infractions_url) }
      format.xml  { head :ok }
    end
  end
end
