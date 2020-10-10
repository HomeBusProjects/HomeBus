class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]

  has_many :devices

  has_one :mosquitto_account
  has_many :mosquitto_acl

  belongs_to :network

  scope :owned_by, -> (user) { ProvisionRequest.where(network_id: user.networks.pluck(:id)) }

  def get_refresh_token(user)
    payload = {
      kind: 'refresh',
      provision_request: {
        name: friendly_name,
        id: self.id
      },
      user: {
        id: user.id
      }
    }

    JsonWebToken.encode(payload, Time.now + 1.year)
  end

  def self.find_by_refresh_token(token)
    begin
      request = JsonWebToken.decode(token)

      if Time.now.to_i > request["exp"]
        return nil
      end

      ProvisionRequest.find request["provision_request"]["id"]
    rescue
      nil
    end
  end

end
