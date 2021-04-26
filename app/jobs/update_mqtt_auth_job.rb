# frozen_string_literal: true

require 'net/ssh'

class UpdateMqttAuthJob < ApplicationJob
  queue_as :default

  def perform(pr)
    command = "PGPASSWORD='#{ENV['MOSQUITTO_POSTGRESQL_PASSWORD']}' psql -h localhost -p 5432 -U #{ENV['MOSQUITTO_POSTGRESQL_USERNAME']} -d #{ENV['MOSQUITTO_POSTGRESQL_DATABASE']}"

    sql_commands = <<~END_OF_ACCOUNT
      INSERT INTO "mosquitto_accounts" ("id", "password", "provision_request_id", "superuser", "enabled", "created_at", "updated_at") VALUES ('#{pr.account_id}', '#{pr.account_encrypted_password}', '#{pr.id}', false, true, NOW(), NOW()) ON CONFLICT ("id") DO UPDATE SET "password" = '#{pr.account_encrypted_password}', "updated_at" = NOW();
    END_OF_ACCOUNT

    sql_commands += MosquittoAcl.from_provision_request2(pr)

    puts sql_commands
    puts command

    result = ''

    Net::SSH.start(ENV['AUTOSSH_HOST'], ENV['AUTOSSH_USER'], key_data: ENV['AUTOSSH_PRIVATE_KEY']) do |session|
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

    pr.ready = true
    pr.save
  end
end
