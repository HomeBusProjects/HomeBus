class CleanupTemporaryRequestsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ProvisionRequest.where('autoremove_at < ?', Time.now).destroy_all
  end
end
