class AccessLevel < ActiveRecord::Base
  has_and_belongs_to_many	:staffs, :join_table => "staff_organizations"
# FIXME This should not be here.

  def save
    self.display_name = self.name.underscore.titleize if self.display_name.nil?
	super
  end
  
  def <=> other
	self.display_name <=> other.display_name
  end

end
