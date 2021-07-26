# frozen_string_literal: true

class ProvisionRequest < ApplicationRecord
  enum status: { unanswered: 0, accepted: 1, denied: 2 }

  has_many :devices, dependent: :destroy
  has_many :tokens, dependent: :destroy

  has_one :mosquitto_account, dependent: :destroy
  has_many :mosquitto_acl, dependent: :destroy

  belongs_to :network
  belongs_to :user

  scope :owned_by, ->(user) { ProvisionRequest.where(network_id: user.networks.pluck(:id)) }

  def get_refresh_token(user)
    payload = {
      kind: 'refresh',
      provision_request: {
        name: friendly_name,
        id: id
      },
      user: {
        id: user.id
      },
      created_at: Time.now.to_i
    }

    JsonWebToken.encode(payload, Time.zone.now + 1.year)
  end

  def accept!
    accepted!

    ro_ddcs.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    wo_ddcs.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    #    self.create_mosquitto_account(superuser: false, password: SecureRandom.base64(32), enabled: true)

    ma = MosquittoAccount.new

    self.account_id = SecureRandom.uuid
    #    self.account_password = ma.generate_pbkdf2_password!
    self.account_password = ma.generate_password!
    self.account_encrypted_password = ma.password
    self.save

    UpdateMqttAuthJob.perform_later(self)

    #    MosquittoAcl.from_provision_request2 self
  end

  def revoke!
    mosquitto_account.update(enabled: false)
  end

  def self.find_by_refresh_token(token)
    request = JsonWebToken.decode(token)

    return nil if Time.now.to_i > request['exp']

    ProvisionRequest.find request['provision_request']['id']
  rescue StandardError
    nil
  end
end
