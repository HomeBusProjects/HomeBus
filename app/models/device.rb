class Device < ApplicationRecord
  belongs_to :provision_request

#  has_many :devices_networks
#  has_many :networks, through: :devices_networks

  has_and_belongs_to_many :devices
end
