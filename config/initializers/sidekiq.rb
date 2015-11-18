Sidekiq.logger.formatter = proc do |severity, datetime, progname, msg|
  "[#{severity}] [#{datetime.utc.iso8601}] [PID=#{Process.pid}] [TID=#{Thread.current.object_id.to_s(36)}] #{L.data} #{msg}\n"
end

class MyMiddleware
  def initialize(options=nil)
    @redis = Redis.new
  end

  def call(worker, msg, queue)
    rid = @redis.hget("logger:rid", msg["jid"])
    L.init(rid, Sidekiq.logger)
    yield
    RequestStore.clear!
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.prepend MyMiddleware
  end
end

class MyClientMiddleware
  def initialize(options=nil)
    @redis = Redis.new
  end

  def call(worker_class, msg, queue, redis_pool)
    @redis.hset("logger:rid", msg["jid"], L.rid)
    yield
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add MyClientMiddleware
  end
end
