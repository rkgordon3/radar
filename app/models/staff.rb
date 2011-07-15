class Staff < ActiveRecord::Base
  has_many :staff_organizations, :dependent => :destroy
  has_many :staff_areas, :dependent => :destroy
  belongs_to :access_level
  belongs_to :area
  belongs_to :organization
  has_many :notification_preferences
  before_save :lower_email
  after_initialize :set_active
  
 
  def devise_creation_param_handler(params)
    params[:staff_areas] = [ StaffArea.new(:staff_id => self.id, :area_id => params[:staff_areas]) ]
    params[:staff_organizations] = [ StaffOrganization.new(:staff_id => self.id, :organization_id => params[:staff_organizations]) ]
  end

  def get_registerable_access_levels
    if self.access_level_id > 1
      #can only register access levels below current level
      return AccessLevel.where(:id=> 1..(self.access_level_id-1))
    else
      #if level 1, can register as level 1 (only to be used when updating self)
      return AccessLevel.where(:id=> self.access_level_id)
    end
  end

  def access_level?(access_level)
    if self.access_level == nil
      return false
    end

    return self.access_level.name == access_level.to_s.camelize
  end

  def get_registerable_organizations
    reg_org_ids = Array.new
    self.staff_organizations.each do |staff_org|
      reg_org_ids << staff_org.organization.id
    end
    
    return Organization.where(:id=>reg_org_ids).order(:name)
  end

  def organization?(organization)
    if self.staff_organizations.first == nil
      return false
    end
    
    return self.staff_organizations.first.organization.name == organization.to_s.camelize
  end

  def lower_email
    self.email = email.downcase
  end
  
  def on_duty?
    current_shift != nil
  end
  
  def on_round?
    (Round.where(:shift_id => current_shift.id, :end_time => nil).first != nil) rescue false
  end
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  
 
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :area, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :access_level_id, :active, :staff_areas, :staff_organizations

 
  
  
  def set_active
    self.active = true
  end
  
  
  def current_shift
    Shift.where(:staff_id => self.id, :time_out => nil).first 
  end
  
  def currently_assigned_tasks
    Shift.find(self.current_shift.id).task_assignments rescue []
  end
  
  def update_attributes(staff)
    sa = StaffArea.where(:staff_id => self.id).first
    sa.area_id = staff[:staff_areas]
    sa.save
    so = StaffOrganization.where(:staff_id => self.id).first
    so.organization_id = staff[:staff_organizations]
    so.save
    staff[:staff_areas] = [sa]
    staff[:staff_organizations] = [so]
    super(staff)
  end
  
end
