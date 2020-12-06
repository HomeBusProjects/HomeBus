class PublishDevicesJob < ApplicationJob
  queue_as :default

  DDC = 'org.homebus.experimental.homebus.devices'

  def perform(*networks)
    devices = []
    network.devices.each do |device|
      devices.push({
                     name: device.friendly_name,
                     uuid: device.id,
                     consumes: device.ddcs.pluck(:name),
                     publishes: device.ddcs.pluck(:name),
                     temporary: !network.provision_request.autoremoval_interval.nil?
                     public: false
                   })
    end

    conn_opts = {
      remote_host: network.broker.name,
      remote_port: network.broker.secure_port,
      username: network.mosquitto_account.id,
      password: network.mosquitto_account.generate_password!
    }

    mqtt = MQTT::Client.connect(conn_opts) do |c|
      c.publish "homebus/device/#{device.uuid}/#{DDC}", JSON.generate(devices), true
    end
  end
end
