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

  after_create :set_user

  def set_user
    self.users << self.provision_request.user
  end

  def set_network
    self.networks << self.provision_request.network
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
