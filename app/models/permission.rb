# frozen_string_literal: true

class Permission < ApplicationRecord
  belongs_to :device
  belongs_to :network
  belongs_to :ddc

  def self.from_device(device, network)
    device.provision_request.ro_ddcs.each do |ddc_name|
      ddc = Ddc.find_by name: ddc_name
      device.ddcs << ddc
      Permission.create(device: device, ddc: ddc, network: network, consumes: true, publishes: false)
    end

    device.provision_request.wo_ddcs.each do |ddc_name|
      ddc = Ddc.find_by name: ddc_name
      device.ddcs << ddc
      Permission.create(device: device, ddc: ddc, network: network, publishes: true, consumes: false)
    end
  end
end
