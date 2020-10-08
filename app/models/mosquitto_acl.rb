class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe

  def self.from_provision_request(pr)
    account = MosquittoAccount.find_by provision_request_id: pr.id

    ActiveRecord::Base.transaction do
      pr.mosquitto_acl.delete_all

      pr.devices.each do |device|
        device.wo_ddcs.each do |ddc|
          # only do this if permitted
          MosquittoAcl.create username: account.username,
                              topic: "homebus/device/#{device.id}/#{ddc}",
                              permissions: :read,
                              provision_request_id: pr.id
        end

        device.ro_ddcs.each do |ddc|
          # only do this if permitted
          MosquittoAcl.create username: account.username,
                              topic: "homebus/device/+/#{ddc}",
                              permissions: :write,
                              provision_request_id: pr.id
        end
      end
    end
  end
end
