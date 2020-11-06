require 'json_web_token'

class Network < ApplicationRecord
  has_and_belongs_to_many :devices

  has_many :permissions, dependent: :delete_all

  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :provision_requests

  belongs_to :broker, counter_cache: true

  validates :name, presence: true

  def get_auth_token(user)
    payload = {
      kind: 'auth',
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

  def self.find_from_auth_token(token)
    begin
      request = JsonWebToken.decode(token)

      if Time.now.to_i > request["exp"]
        return nil
      end

      Network.find request["network"]["id"]
    rescue
      nil
    end
  end
end
