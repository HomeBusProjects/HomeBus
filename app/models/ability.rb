# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present? # additional permissions for logged in users (they can manage their posts)
      if user.site_admin? # additional permissions for administrators
        can :manage, :all
        return
      end

      can :manage, User, id: user.id # permissions for every user, even if not logged in
      can :manage, Network, id: user.networks.pluck(:id)
      can %i[create new], Network

      can :manage, ProvisionRequest, user_id: user.id

      can :manage, Device, id: user.devices.pluck(:id)
      can :read, Ddc

      # Network, Broker, User, Device, ProvisionRequest, MosquittoAccount, MosquittoAcl

    end
  end
end
