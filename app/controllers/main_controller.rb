class MainController < ApplicationController
  def index
    Rails.logger.tagged("BCX", "Jason") { Rails.logger.info "Stuff" }
    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    sleep 0.2

    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    L.i("foo bar baz")

    sleep 0.2
    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    HardWorker.perform_async('bob', 5)
  end
end
