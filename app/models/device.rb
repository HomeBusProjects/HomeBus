# frozen_string_literal: true

class Device < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :provision_request

  has_and_belongs_to_many :networks, dependent: :destroy, through: :networks_users
  has_and_belongs_to_many :users, dependent: :destroy, through: :devices_users

  has_and_belongs_to_many :ddcs

  has_many :permissions, dependent: :destroy
  has_one :public_device, dependent: :destroy
  has_one :token, dependent: :destroy

  after_create :complete_setup

  def complete_setup
    self.users << self.provision_request.user
    self.networks << self.provision_request.network

    Token.create(name: "manage device #{self.friendly_name}", scope: 'device:manage', device: self, enabled: true)

    UpdateMqttAclJob.perform_later(self.provision_request)
  end

  def to_json(with_token = false)
    json = {
      id: self.id,
      name: self.friendly_name,
      identity: {
        manufacturer: self.manufacturer,
        model: self.model,
        serial_number: self.serial_number
      }
    }

    if with_token
      json[:token] = self.token.id
    end

    json
  end
end
