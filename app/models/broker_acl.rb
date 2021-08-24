# frozen_string_literal: true

class BrokerAcl < ApplicationRecord
  include Bitfields

  belongs_to :provision_request
  belongs_to :broker_account

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    puts "ACCOUNT ID #{pr.broker_account.id}"

    records = "BEGIN;\n\n"
    records += "DELETE FROM \"mosquitto_acls\" WHERE \"consumer_provision_request_id\" = '#{pr.id}' OR \"publisher_provision_request_id\" = '#{pr.id}';\n\n"
    records += "INSERT INTO \"mosquitto_acls\" (\"username\", \"topic\", \"consumer_provision_request_id\", \"publisher_provision_request_id\", \"permissions\", \"created_at\", \"updated_at\") VALUES\n"

    raw_records = []

    # allow subscriptions to homebus/device/+/DDC for each DDC
    pr.consumes.each do |ddc|
      raw_records.push "\t('#{pr.broker_account.id}', 'homebus/device/+/#{ddc}', '#{pr.id}', NULL, 4, NOW(), NOW())"
    end

    # allow publication to homebus/device/ID/DDC for each publish DDC
    pr.publishes.each do |ddc|
      pr.devices.each do |device|
        raw_records.push "\t('#{pr.broker_account.id}', 'homebus/device/#{device.id}/#{ddc}', '#{pr.id}', NULL, 2, NOW(), NOW())"
      end
    end


    pr.devices.each do |device|
      common_devices = _get_all_devices(device)

      # list every single device/DDC combo that the PR is allowed to receive from, with perms 1
      pr.consumes.each do |ddc|
        _ddc_publishes(common_devices, ddc).each do |publisher|
          raw_records.push "\t('#{pr.broker_account.id}', 'homebus/device/#{publisher.id}/#{ddc}', '#{pr.id}', '#{publisher.provision_request_id}', 1, NOW(), NOW())"
        end
      end

      # list every single device/DDC combo that is allowed to consume from this PR, with perms 1
      pr.publishes.each do |ddc|
        _ddc_consumes(common_devices, ddc).each do |consumer|
          raw_records.push "\t('#{consumer.provision_request.broker_account.id}', 'homebus/device/#{device.id}/#{ddc}', '#{consumer.provision_request_id}', '#{pr.id}', 1, NOW(), NOW())"
        end
      end
    end

    records += raw_records.join(",\n")
    records += ";\n"

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug records.inspect.to_s

    records += "COMMIT;\n"
    records
  end

  def self._get_all_devices(d)
    d.networks.all.map { |n| n.devices }.flatten.uniq
  end
    
  def self._ddc_consumes(devices, ddc)
    devices.select { |d| d.provision_request.consumes.include?(ddc) }
  end

  def self._ddc_publishes(devices, ddc)
    devices.select { |d| d.provision_request.publishes.include?(ddc) }
  end

  def self._permit_device(device, pr, permissions)
    records = []

    device.ddcs.each do |ddc|
      Rails.logger.debug "ACL homebus/device/#{device.id}/#{ddc.name} -> #{permissions}"

      records.push "\t('#{pr.broker_account.id}', 'homebus/device/#{device.id}/#{ddc.name}', '#{pr.id}', #{permissions}, NOW(), NOW())"
    end

    records
  end
end
