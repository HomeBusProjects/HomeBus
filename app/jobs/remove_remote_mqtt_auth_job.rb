# frozen_string_literal: true

require 'net/ssh'

class RemoveRemoteMQTTAuthJob < UpdateRemoteBrokerJob
  queue_as :default

  def perform(broker, sql_commands)
    update_remote_broker(broker, sql_commands)
  end
end
