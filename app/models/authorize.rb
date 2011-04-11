class Authorize
  
  def Authorize.ra_authorize(current_staff)
    return current_staff.access_level >= Authorize.ra_access_level
  end
  
  def Authorize.admin_assistant_authorize(current_staff)
    return current_staff.access_level >= Authorize.admin_assistant_access_level
  end
  
  def Authorize.not_admin_assistant_authorize(current_staff)
    return current_staff.access_level != Authorize.admin_assistant_access_level
  end
  
  def Authorize.hd_authorize(current_staff)
    return current_staff.access_level >= Authorize.hd_access_level
  end
  
  def Authorize.admin_authorize(current_staff)
    return current_staff.access_level >= Authorize.admin_access_level
  end
  
  def Authorize.super_admin_authorize(current_staff)
    return current_staff.access_level == Authorize.super_admin_access_level
  end
  
  
  
  
  def Authorize.ra_access_level
    return 1
  end
  
  def Authorize.admin_assistant_access_level
    return 2
  end
  
  def Authorize.hd_access_level
    return 3
  end
  
  def Authorize.admin_access_level
    return 4
  end
  
  def Authorize.super_admin_access_level
    return 5
  end
  
  def Authorize.string_for_access_level(lev)
    if lev == Authorize.ra_access_level
      return "Resident Asst."
    end
    if lev == Authorize.hd_access_level
      return "Hall Director"
    end
    if lev == Authorize.admin_assistant_access_level
      return "Admin Asst."
    end
    if lev == Authorize.admin_access_level
      return "Administrator"
    end
    if lev == Authorize.super_admin_access_level
      return "System Admin"
    end
  end
end
