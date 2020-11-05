class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request
  belongs_to :mosquitto_account

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
            Rails.logger.debug "READ ACL homebus/device/#{p.device.id}/#{device.ddc.name}"

            records.push MosquittoAcl.create(username: account.id,
                                             topic: "homebus/device/#{p.device.id}/#{device.ddc.name}",
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
      records.each { |record| Rails.logger.debug "RECORD #{record.inspect}" ; record.save ; Rails.logger.debug record.errors }
    end
  end

  def self.from_device(device)
    device_publishes = device.ddcs_devices.where(publishable: true).join(:ddcs).pluck(:'ddc.name')
  end

  private
  
end
