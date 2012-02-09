class Ability
  include CanCan::Ability
  def initialize(staff)
    alias_action :start_shift, :end_shift, :update_todo, :start_round, :end_round, :update, :to_do_list, :to => :do
    alias_action :call_log, :duty_log, :to => :shift_log
    alias_action :autocomplete_participant_full_name, :sort_search_results, :search_results, :to => :search
    alias_action :forward_as_mail, :to => :forward
    alias_action :new, :new_with_participants,  :to => :create # I tried to include all actions needed throughout the report creation process -Lyric
	alias_action :update_duration, :update_common_duration, :update_reason, :new_with_participants,
      :update_common_reasons, :render_set_reason, :render_common_reasons_update, :update_common_annotation,
      :update_annotation, :remove_participant, :create_participant_and_add_to_report, :add_participant, :to => :modify_live


	cannot :manage, :all
    if not staff.organizations.empty? 
      staff.organizations.each do |org|
        org.apply_privileges(self, staff)
      end
    else
      # this user does not belong to an organization and is super-user
      can :manage, :all
    end
  end

end
