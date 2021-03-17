class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request
#  belongs_to :mosquitto_account

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    account = MosquittoAccount.find_by provision_request_id: pr.id
    puts "NEW ACCOUNT ID #{account.id}"

    records = []

    pr.devices.each do |device|
      device.ddcs.each do |ddc|
        Rails.logger.debug "PUBLISHES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, publishes: true)
          Rails.logger.debug "WRITE ACL homebus/device/#{device.id}/#{ddc.name}"

            records.push MosquittoAcl.new(username: account.id,
                                          topic: "homebus/device/#{device.id}/#{ddc.name}",
                                          permissions: 2,
                                          provision_request_id: pr.id)
          end

        # for each consumable DDC we need to find all devices on the network which publish
        # that DDC and create an entry permitting us to read and subscribe to them
        puts "CONSUMES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, consumes: true)
          Permission.where(network: pr.network, ddc: ddc, publishes: true).each do |p|
            Rails.logger.debug "READ ACL homebus/device/#{p.device.id}/#{ddc.name}"
            records.push MosquittoAcl.new(username: account.id,
                                          topic: "homebus/device/#{p.device.id}/#{ddc.name}",
                                          permissions: 1+4,
                                          provision_request_id: pr.id)

          end
        end
      end
    end

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug "#{records.inspect}"

    ActiveRecord::Base.transaction do
      pr.mosquitto_acl.delete_all
      records.each { |record| Rails.logger.debug "RECORD #{record.inspect}" ; record.save ; Rails.logger.debug record.errors.inspect }
    end
  end


  def self.from_provision_request_opposite(pr)
    account = MosquittoAccount.find_by provision_request_id: pr.id
    puts "NEW ACCOUNT ID #{account.id}"

    records = []

    pr.devices.each do |device|
      device.ddcs.each do |ddc|
        Rails.logger.debug "PUBLISHES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, publishes: false)
          Rails.logger.debug "WRITE ACL homebus/device/#{device.id}/#{ddc.name}"

            records.push MosquittoAcl.new(username: account.id,
                                          topic: "homebus/device/#{device.id}/#{ddc.name}",
                                          permissions: 0,
                                          provision_request_id: pr.id)
          end

        # for each consumable DDC we need to find all devices on the network which publish
        # that DDC and create an entry permitting us to read and subscribe to them
        puts "CONSUMES PERMISSION CHECK device ID: #{device.id}, network ID: #{pr.network.id}, ddc ID: #{ddc.id}"

        if Permission.find_by(device: device, network: pr.network, ddc: ddc, consumes: true)
          Permission.where(network: pr.network, ddc: ddc, publishes: false).each do |p|
            Rails.logger.debug "READ ACL homebus/device/#{p.device.id}/#{ddc.name}"
            records.push MosquittoAcl.new(username: account.id,
                                          topic: "homebus/device/#{p.device.id}/#{ddc.name}",
                                          permissions: 0,
                                          provision_request_id: pr.id)

          end
        end

        records.push MosquittoAcl.new(username: account.id,
                                      topic: "homebus/device/+/#{ddc.name}",
                                      permissions: 4 + 1,
                                      provision_request_id: pr.id)
      end
    end

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug "#{records.inspect}"

    ActiveRecord::Base.transaction do
      pr.mosquitto_acl.delete_all
      records.each { |record| Rails.logger.debug "RECORD #{record.inspect}" ; record.save ; Rails.logger.debug record.errors.inspect }
    end
  end

  def self.from_provision_request2(pr)
    account = MosquittoAccount.find_by provision_request_id: pr.id
    puts "NEW ACCOUNT ID #{account.id}"

    records = []

    records.push "DELETE FROM \"mosquitto_acls\" WHERE \"mosquitto_acls.provision_request_id\" = \"#{pr.id}\";"

    Device.find_each do |device|
      if device.provision_request == pr
        records += _permit_device(device, account, pr, 2)
        next
      end

      if device.networks.pluck(:id).include?(pr.network.id)
        records += _permit_device(device, account, pr, 5)
        next
      end

      records += _permit_device(device, account, pr, 0)
    end

    Rails.logger.debug "#{records.length} records"
    Rails.logger.debug "#{records.inspect}"

if false
    ActiveRecord::Base.transaction do
      pr.mosquitto_acl.delete_all
      records.each { |record| Rails.logger.debug "RECORD #{record.inspect}" ; record.save ; Rails.logger.debug record.errors.inspect }
    end
end

    return records
  end


  def self.from_device(device)
    device_publishes = device.ddcs_devices.where(publishable: true).join(:ddcs).pluck(:'ddc.name')
  end

  def self._permit_device(device, account, pr, permissions)
    records = []

    device.ddcs.each do |ddc|
      Rails.logger.debug "ACL homebus/device/#{device.id}/#{ddc.name} -> #{permissions}"

      records.push "INSERT INTO \"mosquitto_acls\" (\"username\", \"topic\", \"provision_request_id\", \"permissions\", \"created_at\", \"updated_at\") VALUES ($1, $2, $3, $4, $5, $6) [[\"username\", \"#{account.id}\"], [\"topic\", \"homebus/device/#{device.id}/#{ddc.name}\"], [\"provision_request_id\", \"#{pr.id}\"], [\"permissions\", #{permissions}], [\"created_at\", \"2021-03-16 03:52:12.630393\"], [\"updated_at\", \"2021-03-16 03:52:12.630393\"]];"
    end

    records
  end
end
