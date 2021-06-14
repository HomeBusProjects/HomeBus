require 'securerandom'

class Token < ApplicationRecord
  has_many :scopes, through: :token_scopes
  belongs_to :user

  validates :token, presence: true
  validates :scope, presence: true

  before_create do
    self.token = SecureRandom.base64(48) if token.blank?
  end
end
