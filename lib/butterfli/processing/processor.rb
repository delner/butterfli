module Butterfli::Processing
  class Processor
    attr_accessor :adapter
    def initialize(adapter)
      self.adapter = adapter
    end

    def enqueue(queue, job)
      self.adapter.enqueue(queue, job)
    end
    def dequeue(queue)
      self.adapter.dequeue(queue)
    end
  end
end