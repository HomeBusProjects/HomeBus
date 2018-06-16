class Device < ApplicationRecord
  belongs_to :provision_request
  has_and_belongs_to_many :spaces
end
