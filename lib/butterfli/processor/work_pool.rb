module Butterfli::WorkPool
  def workers
    @workers ||= []
  end
  def start
    self.workers.each { |w| w.start }
  end
  def wakeup
    self.workers.each { |w| w.wakeup }
  end
  def stop
    self.workers.each { |w| w.stop }
  end
  def kill
    self.workers.each { |w| w.kill }
  end
end