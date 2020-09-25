require 'json_web_token'

class Network < ApplicationRecord
  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :provision_requests

  validates :name, :entropy, presence: true

  def get_auth_token(user)
    pp user
    
    payload = {
      network: {
        name: name,
        id: id
      },
      user: {
        id: user.id
      }
    }

    JsonWebToken.encode(payload)
  end
end
