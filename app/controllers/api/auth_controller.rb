class Api::AuthController < Api::ApplicationController
  before_action :api_authenticate!, only: [ :delete ]

  # POST /api/auth
  def create
    pp params

    email = params[:email_address]
    password = params[:password]

    user = User.find_for_authentication email: params[:email_address]

    # https://github.com/heartcombo/devise/wiki/How-To:-Find-a-user-when-you-have-their-credentials
    unless user && user.active_for_authentication? && user.valid_password?(params[:password])
      render json: "invalid credentials", status: 401
      return
    end

    networks = user.networks
    if networks.count == 0
      render json: "must own at least one network", status: 401
      return
    end

    if networks.count > 1
      render json: { networks: [ networks.map { |network| { id: network.id, name: network.name } } ] }, status: 401
      return
    end

    token = Token.create(user: user, network: networks.first, scope: 'provision_request:create', enabled: true, expires: Time.now + 1.year, name: params[:name])

    render json: { token: token.id }, status: 200
  end

  # DELETE /api/auth/TOKEN
  def destroy
    api_authenticate!

    @token.delete

    render json: "Auth token invalidated", status: 200
  end
end
