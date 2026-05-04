Sidekiq.configure_server do |config|
  config.redis = {
    namespace: 'collect:sidekiq',
    read_timeout: 0.5,
  }
end

Sidekiq.configure_client do |config|
    config.redis = {
      namespace: 'collect:sidekiq',
      read_timeout: 0.5,
    }
end

Sidekiq.default_job_options = { retry: 0 }
