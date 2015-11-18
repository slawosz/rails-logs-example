Rails.application.configure do
  config.middleware.insert_before("Rails::Rack::Logger", "LoggingMiddleware")

  class CustomLogFormatter
    def call(severity, datetime, progname, msg)
      "[#{severity}] [#{datetime.utc.iso8601}] [PID=#{Process.pid}] #{L.data} #{msg}\n"
    end

    # noop, required since logger in rails is by default tagged
    def tagged(*)
      yield
    end

    def clear_tags!;end
  end
  Rails.logger.formatter = CustomLogFormatter.new
end
