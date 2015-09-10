module Butterfli::Processing
  module WorkPool
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

    def alive?
      self.workers.any? { |w| w.alive? }
    end
    def blocking?
      self.workers.all? { |w| w.blocking? }
    end
    def stopped?
      self.workers.all? { |w| w.stopped? }
    end
  end
end