class Devise::RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [  ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy, :new, :create]
  before_filter :instantiate_registerables, :only => [:new,:edit]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_up
  def new
    build_resource({})
    @organizations = current_staff.get_registerable_organizations
    @access_levels = current_staff.get_registerable_access_levels
    render_with_scope :new
  end

  # POST /resource
  def create
    resource.devise_creation_param_handler(params[resource_name])
    build_resource
    
    if resource.save
      set_flash_message :notice, :signed_up
      #sign_in_and_redirect(resource_name, resource)
      redirect_to(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    @staff = Staff.find(params[:id])
    @organizations = current_staff.get_registerable_organizations
    @access_levels = current_staff.get_registerable_access_levels
    render_with_scope :edit
  end

  # PUT /resource
  def update
    params[resource_name].delete(:password) if params[resource_name][:password].blank?
    params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
    @staff = Staff.find(params[resource_name][:id])
    if resource.update_attributes(params[resource_name])
      @current_ability = nil
      @current_staff = nil
      set_flash_message :notice, "Updated Account Successfully"
      redirect_to (resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected

  # Authenticates the current scope and gets a copy of the current resource.
  # We need to use a copy because we don't want actions like update changing
  # the current user in place.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = resource_class.find(send(:"current_#{resource_name}").id)
  end

  def instantiate_registerables
    @organizations ||= Hash.new
    @access_levels ||= Hash.new
  end

end
