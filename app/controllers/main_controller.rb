class MainController < ApplicationController
  def index
    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    sleep 0.2

    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    L.i("foo bar baz")
    Rails.logger.info "foo bar baz"

    sleep 0.2
    L.i("foo bar", "abc", "123", { "2+2" => "4" })
    HardWorker.perform_async('bob', 5)
  end
end
