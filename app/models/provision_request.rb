class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]
  has_many :devices
  has_one :mosquitto_account
  has_many :mosquitto_acl

  def _generate_acls
    wo_ddcs.flat_map do |ddc|
      'homebus/device/' + id + '/' + ddc
    end
  end
end
