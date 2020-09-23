require 'securerandom'
require 'json_web_token'

class Network < ApplicationRecord
  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :networks_provision_requests
  has_many :provision_requests, through: :networks_provision_requests

  validates :name, :entropy, presence: true

  before_validation :create_auth_token

  def reset_entropy
    self.entropy = SecureRandom.base64(20)
  end

  def reset_auth_token
    reset_entropy
    create_auth_token
  end

  private

  def create_auth_token
    reset_entropy

    info = {
      network: {
        name: name,
        id: id
      },
      entropy: entropy
    }

    self.token = JsonWebToken.encode(info)
  end
end
