# frozen_string_literal: true

require 'json_web_token'

class Network < ApplicationRecord
  has_and_belongs_to_many :devices

  has_many :permissions, dependent: :destroy

  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :provision_requests
  has_many :tokens, dependent: :destroy

  has_one :public_network, dependent: :destroy

  belongs_to :broker, counter_cache: true
  belongs_to :announcer, class_name: 'Device', optional: true

  validates :name, presence: true

  def create_homebus_announcer(user)
    pr = ProvisionRequest.create friendly_name: 'Homebus',

                                 network: self,
                                 user: user,
                                 ip_address: '127.0.0.1',
                                 wo_ddcs: ['org.homebus.experimental.homebus.devices'],
                                 ro_ddcs: []



    
    d = Device.create provision_request: pr,
                      friendly_name: 'Homebus Device Announcer',
                      manufacturer: 'Homebus',
                      model: 'Network announcer',
                      serial_number: id,
                      pin: ''

    self.announcer = d
    save

    pr.accept!

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

    JsonWebToken.encode(payload, Time.zone.now + 1.month)
  end

  def self.find_from_auth_token(token)
    begin
      request = JsonWebToken.decode(token)

      if Time.now.to_i > request['exp']
        Rails.logger.error 'request expired'

        return nil
      end

      return request
    rescue StandardError => e
      Rails.logger.error "JsonWebToken exception#{e.backtrace.join("\n")}"

      return nil
    end
  end
end
