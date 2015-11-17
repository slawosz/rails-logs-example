class MyMiddleware
  def initialize(options=nil)
  end

  def call(worker, msg, queue)
    L.init(msg["jid"], Sidekiq.logger)
    puts "we are sending: #{msg}"
    yield
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.prepend MyMiddleware
  end
end

class MyClientMiddleware
  def call(worker_class, msg, queue, redis_pool)
    puts "we are sending: #{msg}"
    msg[:foobar] = 1234
    yield
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add MyClientMiddleware
  end
end
