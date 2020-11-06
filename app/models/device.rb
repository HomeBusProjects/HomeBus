class Device < ApplicationRecord
  belongs_to :provision_request

#  has_many :devices_networks
#  has_many :networks, through: :devices_networks

  has_and_belongs_to_many :networks
  has_and_belongs_to_many :users

  has_and_belongs_to_many :ddcs

  has_many :permissions, dependent: :destroy
end
