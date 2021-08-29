# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :provision_request

  #  has_many :devices_networks
  #  has_many :networks, through: :devices_networks

  has_and_belongs_to_many :networks
  has_and_belongs_to_many :users

  has_and_belongs_to_many :ddcs

  has_many :permissions, dependent: :destroy
  has_one :public_device, dependent: :destroy
  has_many :tokens, dependent: :destroy

  after_create :complete_setup

  def complete_setup
    self.users << self.provision_request.user
    self.networks << self.provision_request.network

    UpdateMqttAclJob.perform_later(self.provision_request)
  end

  def to_json
    {
      id: self.id,
      name: self.friendly_name,
      identity: {
        manufacturer: self.manufacturer,
        model: self.model,
        serial_number: self.serial_number
      }
    }
  end
end
