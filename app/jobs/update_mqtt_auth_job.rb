# frozen_string_literal: true

require 'net/ssh'

class UpdateMqttAuthJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(pr)
    sql_commands = pr.broker_account.to_sql
    sql_commands += BrokerAcl.from_provision_request(pr)

    Rails.logger.info '>>>> MQTT AUTH <<<<'
    Rails.logger.info sql_commands

    update_remote_broker(pr.network.broker, sql_commands)

    pr.ready = true
    pr.save
  end
end
