# frozen_string_literal: true

class CleanupTemporaryRequestsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    ProvisionRequest.where('autoremove_at < ?', Time.zone.now).destroy_all
  end
end
