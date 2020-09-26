require 'json_web_token'

class Network < ApplicationRecord
#  has_many :devices_networks
#  has_many :devices, through: :devices_networks

  has_and_belongs_to_many :devices

  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :provision_requests

  validates :name, :entropy, presence: true

  def get_auth_token(user)
    payload = {
      network: {
        name: name,
        id: id
      },
      user: {
        id: user.id
      }
    }

    pp ENV['NETWORK_AUTH_KEY']

    JsonWebToken.encode(payload)
  end

  def self.find_from_auth_token(token)
    begin
      request = JsonWebToken.decode(token)

      Network.find request["network"]["id"]
    rescue
      nil
    end
  end
end
