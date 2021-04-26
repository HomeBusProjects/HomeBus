# frozen_string_literal: true

set :output, '~/HomeBus/shared/log/whenever.log'

every 1.hour do
  command 'cd ~/HomeBus/current/backup ; backup perform -t hourly_backup'
end
