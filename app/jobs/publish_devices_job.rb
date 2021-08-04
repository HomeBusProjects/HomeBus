# frozen_string_literal: true

require 'pp'

class PublishDevicesJob < ApplicationJob
  queue_as :default

  DDC = 'org.homebus.experimental.homebus.devices'

  discard_on ActiveJob::DeserializationError    

  def perform(network)
    return unless network

    devices = []
    network.devices.each do |device|
      devices.push({
                     name: device.friendly_name,
                     id: device.id,
                     consumes: device.provision_request.ro_ddcs,
                     publishes: device.provision_request.wo_ddcs,
                     temporary: !device.provision_request.autoremove_at.nil?,
                     public: false
                   })
    end

    conn_opts = {
      remote_host: network.broker.name,
      remote_port: network.broker.secure_port,
      username: network.announcer.provision_request.broker_account.id,
      password: network.announcer.provision_request.broker_account.enc_password,
      ssl: true
    }

    homebus_message = {
      source: network.announcer.id,
      timestamp: Time.now.to_i,
      contents: {
        ddc: DDC,
        payload: {
          network: network.name,
          devices: devices
        }
      }
    }

    puts "conn_opts #{conn_opts}"
    puts "message #{homebus_message.pretty_inspect}"

    unless Rails.env.development?
      mqtt = MQTT::Client.connect(conn_opts) do |c|
        c.publish "homebus/device/#{network.announcer.id}/#{DDC}", JSON.generate(homebus_message), true
      end
    end
  end
end
