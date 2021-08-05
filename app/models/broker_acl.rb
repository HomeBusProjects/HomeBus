# frozen_string_literal: true

class BrokerAcl < ApplicationRecord
  include Bitfields

  belongs_to :provision_request
  belongs_to :broker_account

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    puts "ACCOUNT ID #{pr.broker_account.id}"

    records = "BEGIN;\n\n"
    records += "DELETE FROM \"mosquitto_acls\" WHERE \"provision_request_id\" = '#{pr.id}';\n\n"
    records += "INSERT INTO \"mosquitto_acls\" (\"username\", \"topic\", \"provision_request_id\", \"permissions\", \"created_at\", \"updated_at\") VALUES\n"

    raw_records = []

    Device.find_each do |device|
      if device.provision_request == pr
        raw_records += _permit_device(device, pr, 2)
        next
      end

      if device.networks.pluck(:id).include?(pr.network.id)
        raw_records += _permit_device(device, pr, 5)
        next
      end

      raw_records += _permit_device(device, pr, 0)
    end

    records += raw_records.join(",\n")
    records += ";\n"

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug records.inspect.to_s

    records += "COMMIT;\n"
    records
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
