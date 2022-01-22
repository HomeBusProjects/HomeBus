# frozen_string_literal: true

class DevicesNetwork < ApplicationRecord
#  belongs_to :device, counter_cache: :networks_count
#  belongs_to :network, counter_cache: :devices
  belongs_to :device
  belongs_to :network

  validates :device_id, uniqueness: { scope: :network_id }
  after_validation :authorized?

  after_create :refresh_authorization!
  after_create :announce!

  before_destroy :refresh_authorization!
  before_destroy :announce!

  def authorized?
    #    device.public? || network.public?
    true
  end

  def refresh_authorization!
    Rails.logger.info ">>> Authorizing device #{self.device.friendly_name} on network #{self.network.name}"
    UpdateMqttAuthJob.perform_later(self.device.provision_request)
  end

  def announce!
    PublishDevicesJob.perform_later(self.network)
  end
end
