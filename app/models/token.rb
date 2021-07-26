require 'securerandom'

class Token < ApplicationRecord
  belongs_to :user
  belongs_to :provision_request, optional: true
  belongs_to :network, optional: true
  belongs_to :device, optional: true

  validates :scope, presence: true

  before_create do
    self.id = SecureRandom.base64(32) if self.id.blank?
  end
end
