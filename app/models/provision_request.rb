class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]

  has_many :devices

  has_one :mosquitto_account
  has_many :mosquitto_acl

  belongs_to :network

  def get_refresh_token(user)
    payload = {
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
end
