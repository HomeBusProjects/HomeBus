class Network < ApplicationRecord
  has_many :networks_users
  has_many :users, through: :networks_users

  has_many :networks_provision_requests
  has_many :provision_requests, through: :networks_provision_requests
end
