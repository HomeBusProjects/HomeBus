class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request
  belongs_to :mosquitto_account

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    account = MosquittoAccount.find_by provision_request_id: pr.id

    ActiveRecord::Base.transaction do
      pr.mosquitto_acl.delete_all

      pr.devices.each do |device|
        device.ddcs_devices.each do |ddc_device|
          if ddc_device.publishable
            MosquittoAcl.create username: account.id,
                                topic: "homebus/device/#{device.id}/#{ddc_device.ddc.name}",
                                permissions: 2,
                                provision_request_id: pr.id
          end

          # for each consumable DDC we need to find all devices on the network which publish
          # that DDC and create an entry permitting us to read and subscribe to them
          if ddc_device.consumable
            ddc = ddc_device.ddc

            pr.network.devices.each do |d|
              names = DdcsDevice.joins(:ddc).where(device: d, publishable: true).pluck(:'ddcs.name')
              if names.include? ddc_device.ddc.name
                MosquittoAcl.create username: account.id,
                                    topic: "homebus/device/#{d.id}/#{ddc_device.ddc.name}",
                                    permissions: 1+4,
                                    provision_request_id: pr.id
              end
            end
          end
        end
      end
    end
  end

  def self.from_device(device)
    device_publishes = device.ddcs_devices.where(publishable: true).join(:ddcs).pluck(:'ddc.name')
  end

  private
  
end
