module StaffsHelper

  def StaffsHelper.sign_out_confirmation(staff)
    confirmation = ""
    if staff.on_duty?
      confirmation += "You are still on duty"

      if staff.on_round?
        confirmation += " and on a round"
      end
      confirmation += "!\n\n"
    end
    return confirmation + "Are you sure you want to sign out?"
  end
  
  def area_assignment_tag(form, staff)
   #if can? :update_area, resource
	    choice = (staff.assigned_area.id == 0 ? 1 : staff.assigned_area.id) rescue 1
        out = form.collection_select( :staff_areas, Area.order(:name), :id, :name, {:selected => choice}) 
	#lse
	#   out = " #{staff.assigned_area.name}" rescue "None"
	#nd
	 out.html_safe
  end
  
  def update_password_tag(options={})
    out = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	out += label_tag("Update Password?", nil,options.reverse_merge(:class=>'alert_label'))
    out +=	check_box "update_password", nil, :checked=>"checked", :id=>"update_password", :onclick=>"reset_password_fields(this);"
	out.html_safe
  end
  
  def authorization_select_tag(staff)
    out = ""
    Organization.all.each do |org|
	  role = staff.role_in(org)
	  opts = { :onclick=>"reset_box(this);" } 
	  opts.merge!  :disabled=> "disabled"  if cannot?(:register, org) 
	  assignable = AccessLevelsHelper::assignable_by(current_ability) 
	  display = (can?(:register, org) || staff.organizations.include?(org)) ? "block;" : "none;"
	  out += "<div class='field'  style='display:" + display +"' >"
	  out += check_box_tag( "staff[org][]", "#{org.id}", (not role.nil?),opts )
	  out += select_tag("staff[authorization][#{org.id}]",
					options_from_collection_for_select(assignable, "id", "display_name",  (role.nil? ? 1 : role.id) ), opts )
	  out += " in #{label_tag org.display_name}"
	  out += "</div>"
    end
	out.html_safe
  end
end
