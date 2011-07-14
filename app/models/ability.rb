class Ability
  include CanCan::Ability

  def initialize(staff)
    staff ||= Staff.new
    
    if staff.access_level? :system_administrator
      can :manage, :all
      can [:view_student_id, :view_contact_info], Participant
    elsif staff.access_level? :administrator
      can :manage, :all
      can [:view_student_id, :view_contact_info], Participant
    elsif staff.access_level? :hall_director
      can :manage, :all
      can [:view_student_id, :view_contact_info], Participant
      # manage products, assets he owns
      # can :manage, Product do |product|
      #  product.try(:owner) == staff
      #end
      #can :manage, Asset do |asset|
      # asset.assetable.try(:owner) == staff
      # end
    elsif staff.access_level? :administrative_assistant
      can :manage, :all
      can [:view_student_id, :view_contact_info], Participant
    elsif staff.access_level? :resident_assistant
      can :manage, :all
    else
      can :landingpage, :home
    end
  end
end
