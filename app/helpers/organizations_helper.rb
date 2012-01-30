module OrganizationsHelper
  def self.assignable_by(ability) 
    Organization.accessible_by(ability, :assign).sort{|a,b| a.display_name <=> b.display_name}
  end
end
