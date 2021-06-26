require 'securerandom'

class Token < ApplicationRecord
  belongs_to :user

  validates :scope, presence: true

  before_create do
    self.token = SecureRandom.base64(48) if token.blank?
  end
end
