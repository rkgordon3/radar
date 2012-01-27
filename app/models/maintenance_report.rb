class MaintenanceReport < Report
  def can_submit_from_mobile?
    true
  end
  
  def forwardable?
    true
  end
  
  def default_contact_reason
	RelationshipToReport.maintenance_concern
  end

end
