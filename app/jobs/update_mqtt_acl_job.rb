# frozen_string_literal: true

class UpdateMqttAclJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(pr)
    sql_commands = BrokerAcl.from_provision_request(pr)

#    Rails.logger.error '>>> MQTT ACL <<<<'
#    Rails.logger.error sql_commands[0, 20] + '...' + sql_commands[-10, 10]

    update_remote_broker(pr.network.broker, sql_commands)

    pr.ready = true
    pr.save
  end
end
