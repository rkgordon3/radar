class Staff < ActiveRecord::Base
  has_many :organization
  has_many :notification_preferences
  before_save :lower_email
  after_initialize :set_active
  
  
  
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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :access_level, :active 
  
  
  
  def set_active
    self.active = true
  end
  
 
  def current_shift
		Shift.where(:staff_id => self.id, :time_out => nil).first 
  end
  
  
end
