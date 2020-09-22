class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User, user_id: user.id # permissions for every user, even if not logged in    

    if user.present?  # additional permissions for logged in users (they can manage their posts)
      can :manage, User, user_id: user.id 
      if user.site_admin?  # additional permissions for administrators
        can :manage, :all
      end

    end

  end
end
