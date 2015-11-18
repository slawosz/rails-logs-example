class LoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    L.init(env["action_dispatch.request_id"])
    @app.call(env)
  end
end
