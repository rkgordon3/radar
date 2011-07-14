class AccessLevelsController < ApplicationController
  load_resource :except => :destroy
  authorize_resource

  def index

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @access_levels }
    end
  end

  # GET /access_levels/1
  # GET /access_levels/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @access_level }
    end
  end

  # GET /access_levels/new
  # GET /access_levels/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @access_level }
    end
  end

  # GET /access_levels/1/edit
  def edit
  end

  # POST /access_levels
  # POST /access_levels.xml
  def create

    respond_to do |format|
      if @access_level.save
        format.html { redirect_to(@access_level, :notice => 'Access level was successfully created.') }
        format.xml  { render :xml => @access_level, :status => :created, :location => @access_level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @access_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /access_levels/1
  # PUT /access_levels/1.xml
  def update

    respond_to do |format|
      if @access_level.update_attributes(params[:access_level])
        format.html { redirect_to(@access_level, :notice => 'Access level was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @access_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /access_levels/1
  # DELETE /access_levels/1.xml
  def destroy
    @access_level.destroy

    respond_to do |format|
      format.html { redirect_to(access_levels_url) }
      format.xml  { head :ok }
    end
  end
end
