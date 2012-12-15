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
end
