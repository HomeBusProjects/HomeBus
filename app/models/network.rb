require 'json_web_token'

class Network < ApplicationRecord
  has_and_belongs_to_many :devices

  has_many :permissions, dependent: :destroy

  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :provision_requests

###  belongs_to :broker
  belongs_to :broker, counter_cache: true
#  has_one :homebus_device

  validates :name, presence: true

#  after_create :create_homebus_device

  def create_homebus_device(user)
    pr = ProvisionRequest.create friendly_name: 'Homebus',
                                 manufacturer: 'Homebus',
                                 model: 'Network attachment',
                                 serial_number: self.id,
                                 pin: '',
                                 network: self,
                                 user: user,
                                 ip_address: '127.0.0.1',
                                 requested_uuid_count: 1,
                                 wo_ddcs: [ 'org.homebus.experimental.homebus.devices' ],
                                 ro_ddcs: []

    pr.accept!

#    self.homebus_device = pr.devices.first
  end

  def get_auth_token(user)
    payload = {
      kind: 'auth',
      network: {
        name: name,
        id: id
      },
      user: {
        id: user.id
      },
      created_at: Time.now.to_i
    }

    JsonWebToken.encode(payload)
  end

  def self.find_from_auth_token(token)
    begin
      request = JsonWebToken.decode(token)

      if Time.now.to_i > request["exp"]
        Rails.logger.error "request expired"

        return nil
      end

      request
    rescue => e
      Rails.logger.error "JsonWebToken exception" + e.backtrace

      nil
    end
  end
end
