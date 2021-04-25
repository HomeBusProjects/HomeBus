if Rails.env.development? || Rails.env.test?
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://redis:6379/0' }
  end
end
