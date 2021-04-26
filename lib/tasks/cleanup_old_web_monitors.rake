# frozen_string_literal: true

desc 'Populate device/ddc table'
task cleanup_old_web_monitors: :environment do
  CleanupTemporaryRequestsJob.perform_later
end
