# frozen_string_literal: true

desc 'Add missing tokens'
task missing_tokens: :environment do
  Device.all.each do |device|
    unless device.token
      puts "device missing token #{device.friendly_name}"
      device.token = Token.create(name: "manage device #{self.friendly_name}", scope: 'device:manage', device: self, enabled: true)
      device.save
    end
  end

  ProvisionRequest.all.each do |pr|
    unless pr.token
      puts "pr missing token #{pr.friendly_name}"
      pr.token = Token.create(name: "manage #{self.friendly_name}", scope: 'provision_request:manage', provision_request: self, enabled: true)
      pr.save
    end
  end
end
