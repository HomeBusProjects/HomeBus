# frozen_string_literal: true

require 'net/ssh'

class UpdateRemoteBrokerJob < ApplicationJob
  queue_as :default

  def update_remote_broker(broker, sql_commands)
    command = "PGPASSWORD='#{broker.postgresql_password}' psql -h localhost -p 5432 -U #{broker.postgresql_username} -d #{broker.postgresql_database}"

    result = ''

    unless Rails.env.development?
      Net::SSH.start(broker.ssh_hostname, broker.ssh_username, key_data: broker.ssh_key) do |session|
        session.open_channel do |channel|
          channel.exec(command) do |ch, success|
            raise 'could not execute command' unless success

            ch.send_data sql_commands
            ch.eof!

            ch.on_data { |_c, data| print data }
            ch.on_extended_data { |_c, _type, data| print data }
          end
        end

        session.loop
      end
    end
  end
end
