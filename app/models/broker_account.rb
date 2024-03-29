# frozen_string_literal: true

require 'securerandom'
require 'base64'
require 'bcrypt'

class BrokerAccount < ApplicationRecord
  belongs_to :provision_request
  belongs_to :broker

  has_many :broker_acl

  before_create :generate_password!
  after_create :schedule_remote_create
  before_destroy :schedule_remote_delete

  def generate_password!
    unencoded_password = SecureRandom.base64(40)

    BCrypt::Engine.cost = 12

    hashed_password = BCrypt::Password.create unencoded_password

    self.password = hashed_password
    self.enc_password = unencoded_password

    unencoded_password
  end
  
  def fix_password!
    BCrypt::Engine.cost = 12

    hashed_password = BCrypt::Password.create self.enc_password

    self.password = hashed_password
    self.enc_password
    self.save
    UpdateMqttAuthJob.perform_later(self.provision_request)
  end

  def schedule_remote_delete
    records = "BEGIN;\n\n"
    records += "DELETE FROM \"mosquitto_accounts\" WHERE \"id\" = '#{self.id}';\n\n"
    records += "DELETE FROM \"mosquitto_acls\" WHERE \"username\" = '#{self.id}';\n\n"
    records += "COMMIT;\n\n"

    RemoveRemoteMQTTAuthJob.perform_later(self.broker, records)
  end

  def schedule_remote_create
    Rails.logger.info 'schedule_remote_create: UpdateMQTTAuthJob'
    UpdateMqttAuthJob.perform_later(self.provision_request)
  end

  def to_sql
    records = "BEGIN;\n\n"
    records += "DELETE FROM \"mosquitto_accounts\" WHERE \"id\" = '#{self.id}';\n\n"
    records += "INSERT INTO \"mosquitto_accounts\" (\"id\", \"password\", \"provision_request_id\", \"superuser\", \"enabled\", \"created_at\", \"updated_at\") VALUES\n"
    records += "\t('#{self.id}', '#{self.password}', '#{self.provision_request.id}', '#{self.superuser}', '#{self.enabled}', NOW(), NOW());\n\n"
    records += "COMMIT;\n\n"
  end
end
