class Ability
  include CanCan::Ability
  def initialize(staff)
    alias_action :start_shift, :end_shift, :update_todo, :start_round, :end_round, :update, :to => :do
    alias_action :call_log, :duty_log, :to => :shift_log
    alias_action :forward_as_mail => :forward

    staff ||= Staff.new
    begin
       staff.organizations.each do |org|
	     org.apply_privileges(self, staff)
	   end
    rescue => e
      # this user does not belong to an organization and is therefore not logged in
      can :landingpage, :home
    end
  end

end
