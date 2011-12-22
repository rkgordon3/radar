class Ability
  include CanCan::Ability
  def initialize(staff)
    alias_action :start_shift, :end_shift, :update_todo, :start_round, :end_round, :update, :to_do_list, :to => :do
    alias_action :call_log, :duty_log, :to => :shift_log
	alias_action :autocomplete_participant_full_name, :search_results, :to => :search
    alias_action :forward_as_mail => :forward

    staff ||= Staff.new
    if not staff.organizations.empty? 
       staff.organizations.each do |org|
	     org.apply_privileges(self, staff)
	   end
    else
      # this user does not belong to an organization and is super-user
	  puts "**************Applying super user abilities"
      can :manage, :all
    end
  end

end
