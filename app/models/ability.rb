class Ability
  include CanCan::Ability

  def initialize(staff)
    staff ||= Staff.new
    
    if staff.access_level? :system_administrator
      can :access, :all
    elsif staff.access_level? :administrator
      can :access, :all
    elsif staff.access_level? :hall_director
      can :access, :all
      # manage products, assets he owns
      # can :manage, Product do |product|
      #  product.try(:owner) == staff
      #end
      #can :manage, Asset do |asset|
      # asset.assetable.try(:owner) == staff
      # end
    elsif staff.access_level? :administrative_assistant
      can :access, :all
    elsif staff.access_level? :resident_assistant
      can :access, :all
    else
      can :access, [:"devise/sessions"]
      can :landingpage, :home
    end
  end
end
