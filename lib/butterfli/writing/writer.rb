module Butterfli::Writing
  class Writer
    # Class
    def self.channel(name, &block)
      (@channels ||= {})[name] = block
    end
    def self.channels
      channels = (@channels ||= {}).dup
      if self.superclass.respond_to?(:channels)
        self.superclass.channels.merge(channels)
      else
        channels
      end
    end

    # Instance
    attr_accessor :write_error_block

    def initialize(options = {})
      self.write_error_block = options[:write_error_block]
    end
    def write_with_error_handling(channel, output)
      begin
        self.write(channel, output)
      rescue Exception => error
        return_value = false
        if !self.write_error_block.nil?
          return_value = self.write_error_block.call(error, output) rescue false
        end
        raise if !(error.class <= StandardError)
        return_value
      end
    end
    def write(channel, output)
      if channel_block = self.class.channels[channel]
        channel_block.call(output)
        true
      else
        raise ArgumentError, "#{self.class.name} does not have a '#{channel}' channel to write output to!"
      end
    end
  end
end