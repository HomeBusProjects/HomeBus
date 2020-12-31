class PublishDevicesJob < ApplicationJob
  queue_as :default

  DDC = 'org.homebus.experimental.homebus.devices'

  def perform(*networks)
    devices = []
    network.devices.each do |device|
      devices.push({
                     name: device.friendly_name,
                     uuid: device.id,
                     consumes: device.provision_request.ro_ddcs.pluck(:name),
                     publishes: device.provision_request.wo_ddcs.pluck(:name),
                     temporary: !device.provision_request.autoremoval_at.nil?,
                     public: false
                   })
    end

    conn_opts = {
      remote_host: network.broker.name,
      remote_port: network.broker.secure_port,
      username: network.announcer.mosquitto_account.id,
      password: network.announcer.mosquitto_account.generate_password!
    }

    homebus_message = {
      source: network.announcer.id,
      timestamp: Time.now.to_i,
      contents: {
        ddc: DDC,
        payload: devices
      }
    }

    mqtt = MQTT::Client.connect(conn_opts) do |c|
      c.publish "homebus/device/#{device.uuid}/#{DDC}", JSON.generate(homebus_message), true
    end
  end
end
