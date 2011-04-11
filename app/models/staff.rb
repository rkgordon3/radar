class Staff < ActiveRecord::Base
	has_many :notification_preferences
    before_save :lower_email
    def lower_email
      self.email = email.downcase
    end
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :access_level, :active 

end
