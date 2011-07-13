class Ability
  include CanCan::Ability

  def initialize(staff)
    staff ||= Staff.new #guest staff

    if staff.access_level? :system_administrator
      can :manage, :all
    elsif staff.access_level? :administrator
      can :manage, :all
    elsif staff.access_level? :hall_director
      can :manage, :all
      # manage products, assets he owns
      # can :manage, Product do |product|
      #  product.try(:owner) == staff
      #end
      #can :manage, Asset do |asset|
      # asset.assetable.try(:owner) == staff
      # end
    elsif staff.access_level? :administrative_assistant
      can :manage, :all
    elsif staff.access_level? :resident_assistant
      can :manage, :all
    end
  end
end
