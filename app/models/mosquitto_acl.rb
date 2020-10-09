class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request

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
                                permissions: 1,
                                provision_request_id: pr.id
          end

          if ddc_device.consumable
            # must iterate through all publishers
            ddc_device.ddc.devices do |device|
              MosquittoAcl.create username: account.id,
                                  topic: "homebus/device/#{d.id}/#{ddc_device.ddc.name}",
                                  permissions: 2,
                                  provision_request_id: pr.id
          end
        end
      end
    end
  end
end
