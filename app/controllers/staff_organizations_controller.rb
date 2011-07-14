class StaffOrganizationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /staff_organizations
  # GET /staff_organizations.xml
  def index
    @staff_organizations = StaffOrganization.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_organizations }
    end
  end

  # GET /staff_organizations/1
  # GET /staff_organizations/1.xml
  def show
    @staff_organization = StaffOrganization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_organization }
    end
  end

  # GET /staff_organizations/new
  # GET /staff_organizations/new.xml
  def new
    @staff_organization = StaffOrganization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_organization }
    end
  end

  # GET /staff_organizations/1/edit
  def edit
    @staff_organization = StaffOrganization.find(params[:id])
  end

  # POST /staff_organizations
  # POST /staff_organizations.xml
  def create
    @staff_organization = StaffOrganization.new(params[:staff_organization])

    respond_to do |format|
      if @staff_organization.save
        format.html { redirect_to(@staff_organization, :notice => 'Staff organization was successfully created.') }
        format.xml  { render :xml => @staff_organization, :status => :created, :location => @staff_organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staff_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staff_organizations/1
  # PUT /staff_organizations/1.xml
  def update
    @staff_organization = StaffOrganization.find(params[:id])

    respond_to do |format|
      if @staff_organization.update_attributes(params[:staff_organization])
        format.html { redirect_to(@staff_organization, :notice => 'Staff organization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_organizations/1
  # DELETE /staff_organizations/1.xml
  def destroy
    @staff_organization = StaffOrganization.find(params[:id])
    @staff_organization.destroy

    respond_to do |format|
      format.html { redirect_to(staff_organizations_url) }
      format.xml  { head :ok }
    end
  end
end
