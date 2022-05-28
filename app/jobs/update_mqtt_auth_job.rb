# frozen_string_literal: true

class UpdateMqttAuthJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(pr)
    sql_commands = pr.broker_account.to_sql
    sql_commands += BrokerAcl.from_provision_request(pr)

    Rails.logger.error '>>>> MQTT AUTH <<<<'
    #    Rails.logger.error sql_commands[0, 20] + '...' + sql_commands[-10, 10]
    Rails.logger.error sql_commands

    update_remote_broker(pr.network.broker, sql_commands)

    pr.ready = true
    pr.save
  end
end
