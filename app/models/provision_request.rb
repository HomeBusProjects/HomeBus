class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]

  has_many :devices

  has_one :mosquitto_account
  has_many :mosquitto_acl

  has_many :networks_provision_requests, dependent: :destroy
  has_many :networks, through: :networks_provision_requests

  def _generate_acls
    wo_ddcs.push('org.homebus.experimental.error').flat_map do |ddc|
      allocated_uuids.push(id).map do |uuid|
        'homebus/device/' + uuid + '/' + ddc
      end
    end
  end

  def _generate_uuids
    allocated_uuids = []
    requested_uuid_count.times do
      loop do
        uuid = SecureRandom.uuid

        if !ProvisionRequest._uuid_in_use?(uuid)
          allocated_uuids.push uuid
          break
        end
      end
    end
  end

  def self._uuid_in_use? uuid
    if ProvisionRequest.where(id: uuid).count > 0
      return true
    end
      
    ProvisionRequest.where("? = ANY(allocated_uuids)", uuid).count > 0
  end
end
