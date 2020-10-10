class Ability
  include CanCan::Ability

  def initialize(user)
    logger.debug 'ABILITY'
    logger.unknown '1. can :manage, ProvisionRequest', user.networks.pluck(:id), pr.network_id

    if user.present?  # additional permissions for logged in users (they can manage their posts)
      if user.site_admin?  # additional permissions for administrators
        can :manage, :all
        return
      end

      can :manage, User, id: user.id # permissions for every user, even if not logged in    
      can :manage, Network, id: user.networks.pluck(:id)
      can [ :create, :new], Network
      #      can :manage, ProvisionRequest, id: ProvisionRequest.owned_by(user)
      can :manage, ProvisionRequest do |pr|
        logger.unknown '2. can :manage, ProvisionRequest', user.networks.pluck(:id), pr.network_id

        user.networks.pluck(:id).include?(pr.network_id)
      end

      can :manage, Device, id: user.devices.pluck(:id)
      can :read, Ddc

      # Network, Broker, User, Device, ProvisionRequest, MosquittoAccount, MosquittoAcl

    end
  end
end
