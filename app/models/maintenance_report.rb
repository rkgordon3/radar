class MaintenanceReport < Report
  def can_submit_from_mobile?
    true
  end
  
  def forwardable?
    true
  end
end
