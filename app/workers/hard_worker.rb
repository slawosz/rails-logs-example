class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    L.i("worker", "worker", "worker")
    sleep 2
    L.i("worker", "worker", "worker")
  end
end
