class Staff < ActiveRecord::Base
  has_many :staff_organizations, :dependent => :destroy
  has_and_belongs_to_many :organizations, :join_table => :staff_organizations
  has_and_belongs_to_many	:access_levels, :join_table => :staff_organizations
  has_many :staff_areas, :dependent => :destroy
  has_many :areas, :through => :staff_areas
  has_many :preferences
  has_many :report_views, :foreign_key => :staff_id, :class_name => "ReportViewLog"
  belongs_to :access_level
  belongs_to :area

  #belongs_to :organization
  has_many :notification_preferences
  before_save :lower_email
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :timeoutable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :remember_me, 
                  :first_name, 
                  :last_name, 
                  :active, 
                 :id

  
  
  #
  # Do not authenticate a user who is not active
  # This method is called out to by devise
  def valid_password?(password)

    logger.debug "valid_password for #{self.email} active: #{self.active}"
    self.active && super(password)
  end
  
  # AccessLevel for staff in a given organization
  def role_in(org)
	 AccessLevel.joins(:staffs).where(:staff_organizations => { :organization_id => org.id, :staff_id => self.id } ).first
  end

  def name
    first_name + " " + last_name
  end
  
  def last_name_first_initial
    last_name + ( ", #{first_name[0]}" rescue "")
  end
  
  # Where does this belong?
  def is_plural?(word)
   word.singularize.pluralize == word
  end
  
  # Return current_access_level based on active organization
  # NOTE (TODO): active organization is currently first in list
  # returned bt staff.organization. THIS IS A KLUDGE. A general
  # fix to ACTIVE ORGANIZATION needs to be implemented.
  def current_access_level	
    staff_org = StaffOrganization.find_by_staff_id_and_organization_id(self.id, active_organization.id)
    AccessLevel.find(staff_org.access_level_id)
  end
  
  def active_organization
    self.organizations.first || Organization.new
  end

  def preference(name)
	name = name.to_s
  # In support of super user (no organization)
	org = self.organizations.first || Organization.new
    prefs = Preference.find_by_staff_id_and_name(self.id, name).value rescue org.send("preferred_#{name.singularize}")

	(prefs.is_a?(Array) and is_plural?(name)) ? prefs : (prefs.is_a?(Array) ? prefs[0] : prefs)
  end
  
  def last_login
    self.last_sign_in_at
  end
  # return true is I have seen given report
  def has_seen? (report)
	not report_views.select { |rv| rv.report_id == report.id }.empty?
  end
  
  # Returns  user's preferred report type
  def preferred_report_type
    ReportType.find_by_name("IncidentReport")
  end
  
  def member_of?(klass)
     not self.organizations.select { |o| o.class.name == klass.name}.empty?
  end
  
  # return an array of staff associated with same areas that I am (current definition of 'adjunct')
  def adjuncts
	Staff.where(:active=>true).joins(:staff_areas, :staff_organizations)
		.where(:staff_areas => { :area_id => self.areas })
		.where(:staff_organizations => { :organization_id => self.organizations })
		.where("staff_areas.staff_id != ?", self.id)
  end
  
  def devise_creation_param_handler(params)
    params[:staff_areas] = [ StaffArea.new( :area_id => params[:staff_areas]) ] unless params[:staff_areas].nil?
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

  def current_shift
    Shift.where(:staff_id => self.id, :time_out => nil).first
  end

  def current_round
    unless self.current_shift.nil?
      Round.where(:end_time => nil, :shift_id => self.current_shift.id).first
    end
  end
  
  def log_type
    access_name = self.access_levels.first.name
    if  access_name == "ResidentAssistant" || access_name == "Staff"
      return "duty"
    elsif access_name == "HallDirector" || access_name == "Supervisor"
      return "call"
    end
    return "no"
  end
  
  def currently_assigned_tasks
    return [] if current_shift.nil?
   
    anytime = -1
    timed_assignments = TaskAssignment.joins(:task).where( "shift_id = ? AND tasks.time > ?", self.current_shift.id, anytime ).order(:time).all
    untimed_assignments = TaskAssignment.joins(:task).where( :shift_id => self.current_shift.id, :tasks => {:time => anytime }).all
    timed_assignments ||= []
    untimed_assignments ||= []
    return timed_assignments + untimed_assignments
  end
  
  
  def assigned_area
	 self.staff_areas.first.area 
  end
  

end
