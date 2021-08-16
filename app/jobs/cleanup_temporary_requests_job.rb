# frozen_string_literal: true

class CleanupTemporaryRequestsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    NetworkMonitor.where('last_accessed < ?', Time.zone.now - 10.minutes).destroy_all
  end
end
