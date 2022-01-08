# frozen_string_literal: true

desc 'Add missing tokens'
task missing_tokens: :environment do
  Device.all.each do |device|
    unless device.token
      puts "device missing token #{device.friendly_name}"
      device.token = Token.create(name: "manage device #{device.friendly_name}", scope: 'device:manage', device: device, enabled: true)
      device.save
    end
  end

  ProvisionRequest.all.each do |pr|
    unless pr.token
      puts "pr missing token #{pr.friendly_name}"
      pr.token = Token.create(name: "manage #{pr.friendly_name}", scope: 'provision_request:manage', provision_request: pr, enabled: true)
      pr.save
    end
  end
end
