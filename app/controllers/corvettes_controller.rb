class CorvettesController < ApplicationController
  # GET /corvettes
  # GET /corvettes.xml
  def index
    @corvettes = Corvette.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @corvettes }
    end
  end

  # GET /corvettes/1
  # GET /corvettes/1.xml
  def show
    @corvette = Corvette.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @corvette }
    end
  end

  # GET /corvettes/new
  # GET /corvettes/new.xml
  def new
    @corvette = Corvette.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @corvette }
    end
  end

  # GET /corvettes/1/edit
  def edit
    @corvette = Corvette.find(params[:id])
  end

  # POST /corvettes
  # POST /corvettes.xml
  def create
    @corvette = Corvette.new(params[:corvette])

    respond_to do |format|
      if @corvette.save
        format.html { redirect_to(@corvette, :notice => 'Corvette was successfully created.') }
        format.xml  { render :xml => @corvette, :status => :created, :location => @corvette }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @corvette.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /corvettes/1
  # PUT /corvettes/1.xml
  def update
    @corvette = Corvette.find(params[:id])

    respond_to do |format|
      if @corvette.update_attributes(params[:corvette])
        format.html { redirect_to(@corvette, :notice => 'Corvette was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @corvette.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /corvettes/1
  # DELETE /corvettes/1.xml
  def destroy
    @corvette = Corvette.find(params[:id])
    @corvette.destroy

    respond_to do |format|
      format.html { redirect_to(corvettes_url) }
      format.xml  { head :ok }
    end
  end
end
