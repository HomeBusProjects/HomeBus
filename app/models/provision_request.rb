class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]
  has_many :devices
  has_one :mosquitto_account
  has_many :mosquitto_acl
end
