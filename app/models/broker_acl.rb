# frozen_string_literal: true

class BrokerAcl < ApplicationRecord
  include Bitfields

  belongs_to :provision_request
  belongs_to :broker_account

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    account = BrokerAccount.find_by provision_request_id: pr.id
    puts "NEW ACCOUNT ID #{account.id}"

    records = []

    pr.devices.each do |device|
      device.ddcs.each do |ddc|
        Rails.logger.debug "PUBLISHES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, publishes: true)
          Rails.logger.debug "WRITE ACL homebus/device/#{device.id}/#{ddc.name}"

          records.push BrokerAcl.new(username: account.id,
                                     topic: "homebus/device/#{device.id}/#{ddc.name}",
                                     permissions: 2,
                                     provision_request_id: pr.id)
        end

        # for each consumable DDC we need to find all devices on the network which publish
        # that DDC and create an entry permitting us to read and subscribe to them
        puts "CONSUMES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        next unless Permission.find_by(device: device, network: pr.network, ddc: ddc, consumes: true)

        Permission.where(network: pr.network, ddc: ddc, publishes: true).find_each do |p|
          Rails.logger.debug "READ ACL homebus/device/#{p.device.id}/#{ddc.name}"
          records.push Broker.new(username: account.id,
                                  topic: "homebus/device/#{p.device.id}/#{ddc.name}",
                                  permissions: 1 + 4,
                                  provision_request_id: pr.id)
        end
      end
    end

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug records.inspect.to_s

    ActiveRecord::Base.transaction do
      pr.broker_acl.delete_all
      records.each do |record|
        Rails.logger.debug "RECORD #{record.inspect}"; record.save; Rails.logger.debug record.errors.inspect
      end
    end
  end

  def self.from_provision_request_opposite(pr)
    account = BrokerAccount.find_by provision_request_id: pr.id
    puts "NEW ACCOUNT ID #{account.id}"

    records = []

    pr.devices.each do |device|
      device.ddcs.each do |ddc|
        Rails.logger.debug "PUBLISHES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, publishes: false)
          Rails.logger.debug "WRITE ACL homebus/device/#{device.id}/#{ddc.name}"

          records.push BrokerAcl.new(username: account.id,
                                     topic: "homebus/device/#{device.id}/#{ddc.name}",
                                     permissions: 0,
                                     provision_request_id: pr.id)
        end

        # for each consumable DDC we need to find all devices on the network which publish
        # that DDC and create an entry permitting us to read and subscribe to them
        puts "CONSUMES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, consumes: true)
          Permission.where(network: pr.network, ddc: ddc, publishes: false).find_each do |p|
            Rails.logger.debug "READ ACL homebus/device/#{p.device.id}/#{ddc.name}"
            records.push BrokerAcl.new(username: account.id,
                                       topic: "homebus/device/#{p.device.id}/#{ddc.name}",
                                       permissions: 0,
                                       provision_request_id: pr.id)
          end
        end

        records.push BrokerAcl.new(username: account.id,
                                      topic: "homebus/device/+/#{ddc.name}",
                                      permissions: 4 + 1,
                                      provision_request_id: pr.id)
      end
    end

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug records.inspect.to_s

    ActiveRecord::Base.transaction do
      pr.broker_acl.delete_all
      records.each do |record|
        Rails.logger.debug "RECORD #{record.inspect}"; record.save; Rails.logger.debug record.errors.inspect
      end
    end
  end

  def self.from_provision_request2(pr)
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

    if false
      ActiveRecord::Base.transaction do
        pr.mosquitto_acl.delete_all
        records.each do |record|
          Rails.logger.debug "RECORD #{record.inspect}"; record.save; Rails.logger.debug record.errors.inspect
        end
      end
    end

    records += "COMMIT;\n"

    records
  end

  def self.from_device(device)
    device_publishes = device.ddcs_devices.where(publishable: true).join(:ddcs).pluck(:'ddc.name')
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
