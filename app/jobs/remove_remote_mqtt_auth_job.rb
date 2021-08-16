# frozen_string_literal: true

require 'net/ssh'

class RemoveRemoteMQTTAuthJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(sql_commands)
    update_remote_broker(pr.network.broker, sql_commands)
  end
end
