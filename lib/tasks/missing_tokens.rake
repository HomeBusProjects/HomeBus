# frozen_string_literal: true

desc 'Add missing tokens'
task missing_tokens: :environment do
  Device.all.each do |device|
    unless device.token
      puts "device missing token #{device.friendly_name}"
    end
  end

  ProvisionRequest.all.each do |pr|
    unless pr.token
      puts "pr missing token #{pr.friendly_name}"
    end
  end
end
