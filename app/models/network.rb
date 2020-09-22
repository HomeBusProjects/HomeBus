class Network < ApplicationRecord
  has_many :networks_users, dependent: :destroy
  has_many :users, through: :networks_users

  has_many :networks_provision_requests, dependent: :destroy
  has_many :provision_requests, through: :networks_provision_requests
end
