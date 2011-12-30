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
end
