class Staff < ActiveRecord::Base
  has_many :staff_organizations, :dependent => :destroy
  has_many :organizations, :through => :staff_organizations
  has_many :staff_areas, :dependent => :destroy
  has_many :areas, :through => :staff_areas
  belongs_to :access_level
  belongs_to :area

  belongs_to :organization
  has_many :notification_preferences
  before_save :lower_email
  after_initialize :set_active
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :timeoutable
  
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :area, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :access_level_id, :active, :staff_areas, :staff_organizations

 
  def name
    first_name + " " + last_name
  end
  
  def last_name_first_initial
    last_name + ( ", #{first_name[0]}" rescue "")
  end
  
  def last_login
    self.last_sign_in_at
  end
  # return true is I have seen given report
  def has_seen? (report)
    ReportViewLog.find_by_staff_id_and_report_id(self.id, report.id) != nil
  end
  
  
  # return an array of staff associated with same areas that I am (current definition of 'adjunct')
  def adjuncts
	Staff.joins(:staff_areas).where('staff_areas.area_id' =>  areas.collect { |a| a.id } ).where("staff_areas.staff_id != ?", self.id)
  end
  
  def devise_creation_param_handler(params)
    params[:staff_areas] = [ StaffArea.new( :area_id => params[:staff_areas]) ]
    params[:staff_organizations] = [ StaffOrganization.new( :organization_id => params[:staff_organizations]) ]
  end

  def registerable_access_levels
    if self.access_level? :system_administrator
      return AccessLevel.all
    elsif self.access_level? :administrator
      return AccessLevel.where(:name => ['AdministrativeAssistant', 'HallDirector', 'ResidentAssistant'])
    elsif self.access_level? :administrative_assistant
      return AccessLevel.where(:name => ['HallDirector', 'ResidentAssistant'])
    elsif self.access_level? :hall_director
      return AccessLevel.where(:name => 'ResidentAssistant')
    elsif self.access_level? :resident_assistant
      return nil
    elsif self.access_level? :campus_safety
      return nil
    end
  end

  def access_level?(access_level)
    self.access_level.name == access_level.to_s.camelize rescue false
  end

  def sign_out_confirmation
    confirmation = ""
    if self.on_duty?
      confirmation += "You are still on duty"

      if self.on_round?
        confirmation += " and on a round"
      end
      confirmation += "!\n\n"
    end
    return confirmation + "Are you sure you want to sign out?"
  end

  # Return those organizations for which I can add users
  # NB: This method has to be written to comprehend staff's
  # ability to add users to a given organization. Code looks
  # something like commented code below.
  def registerable_organizations
   # Organization.all.select { |org| current_ability.can? :manage, StaffOrganization.find_by_organization_id_and_staff_id(org.id, self.id) }
   self.organizations
  end
  
  # Organization in which user is currently acting
  # NB: Degenerate case is 'first' from list of organizations to which
  # user belongs. When full support for multiple orgs is in place, this
  # method we have to be revisited.
  def organization_of_agency
    self.organizations.first
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
  

  
  def set_active
    self.active = true
  end
  
  
  def current_shift
    Shift.where(:staff_id => self.id, :time_out => nil).first
  end

  def current_round
    if self.current_shift != nil
      Round.where(:end_time => nil, :shift_id => self.current_shift.id).first
    end
  end
  
  def currently_assigned_tasks
    if (current_shift == nil)
      return []
    end
    anytime = -1
    timed_assignments = TaskAssignment.joins(:task).where( "shift_id = ? AND tasks.time > ?", self.current_shift.id, anytime ).order(:time).all
    untimed_assignments = TaskAssignment.joins(:task).where( :shift_id => self.current_shift.id, :tasks => {:time => anytime }).all
    timed_assignments ||= []
    untimed_assignments ||= []
    return timed_assignments + untimed_assignments
  end
  
  def update_attributes(staff)
    if staff[:staff_organizations] != nil
      so = StaffOrganization.where(:staff_id => self.id).first
      so.organization_id = staff[:staff_organizations]
      so.save
      staff[:staff_organizations] = [so]
    end
    if staff[:staff_areas] != nil
      sa = StaffArea.where(:staff_id => self.id).first
      sa.area_id = staff[:staff_areas]
      sa.save
      staff[:staff_areas] = [sa]
    end
    
    super(staff)
  end
  
end
