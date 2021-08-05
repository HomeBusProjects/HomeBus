# frozen_string_literal: true

class ProvisionRequest < ApplicationRecord
  enum status: { unanswered: 0, accepted: 1, denied: 2 }

  has_many :devices, dependent: :destroy
  has_one :token, dependent: :destroy

  has_one :mosquitto_account, dependent: :destroy
  has_many :mosquitto_acl, dependent: :destroy

  has_one :broker_account, dependent: :destroy
  has_many :broker_acl, dependent: :destroy

  belongs_to :network
  belongs_to :user

  after_create :get_token

  scope :owned_by, ->(user) { ProvisionRequest.where(network_id: user.networks.pluck(:id)) }

  def accept!
    accepted!

    self.consumes.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    self.publishes.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    Rails.logger.info 'create broker account'
    self.create_broker_account(superuser: false, enabled: true, broker: self.network.broker)

    UpdateMqttAuthJob.perform_later(self)
  end

  def revoke!
    broker_account.update(enabled: false)
  end

  def get_token
    Token.create(name: "manage #{self.friendly_name}", scope: 'provision_request:manage', provision_request: self, enabled: true)
  end

  def to_json
    {
      id: self.id,
      name: self.friendly_name,
      consumes: self.consumes,
      publishes: self.publishes,
    }
  end
end
