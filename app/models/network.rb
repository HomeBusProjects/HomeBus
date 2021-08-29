# frozen_string_literal: true

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
                                 publishes: ['org.homebus.experimental.homebus.devices'],
                                 consumes: []

    
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

  def consumes
    @network.devices.map { |d| d.provision_request.consumes}.flatten.uniq
  end

  def publishes
    @network.devices.map { |d| d.provision_request.publishes}.flatten.uniq
  end
end
