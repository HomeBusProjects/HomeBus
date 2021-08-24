# frozen_string_literal: true

require 'net/ssh'

class UpdateMqttAclJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(pr)
    sql_commands += BrokerAcl.from_provision_request(pr)

    puts sql_commands

    update_remote_broker(pr.network.broker, sql_commands)

    pr.ready = true
    pr.save
  end
end
