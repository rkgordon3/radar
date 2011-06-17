class InterestedPartiesController < ApplicationController
  # GET /interested_parties
  # GET /interested_parties.xml
  def index
    @interested_parties = InterestedParty.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interested_parties }
    end
  end

  # GET /interested_parties/1
  # GET /interested_parties/1.xml
  def show
    @interested_party = InterestedParty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interested_party }
    end
  end

  # GET /interested_parties/new
  # GET /interested_parties/new.xml
  def new
    @interested_party = InterestedParty.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interested_party }
    end
  end

  # GET /interested_parties/1/edit
  def edit
    @interested_party = InterestedParty.find(params[:id])
  end

  # POST /interested_parties
  # POST /interested_parties.xml
  def create
    @interested_party = InterestedParty.new(params[:interested_party])

    respond_to do |format|
      if @interested_party.save
        format.html { redirect_to(@interested_party, :notice => 'Interested party was successfully created.') }
        format.xml  { render :xml => @interested_party, :status => :created, :location => @interested_party }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interested_party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interested_parties/1
  # PUT /interested_parties/1.xml
  def update
    @interested_party = InterestedParty.find(params[:id])

    respond_to do |format|
      if @interested_party.update_attributes(params[:interested_party])
        format.html { redirect_to(@interested_party, :notice => 'Interested party was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interested_party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interested_parties/1
  # DELETE /interested_parties/1.xml
  def destroy
    @interested_party = InterestedParty.find(params[:id])
    @interested_party.destroy

    respond_to do |format|
      format.html { redirect_to(interested_parties_url) }
      format.xml  { head :ok }
    end
  end
end
