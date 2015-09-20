module Butterfli::Regulation::Conditions
  module Rate
    attr_accessor :max, :interval

    def effective_rate
      if self.max && self.interval
        self.max.to_f / self.interval.to_f
      end
    end
    def seconds_per
      if self.max && self.interval
        self.interval.to_f / self.max.to_f
      end
    end
    def self.included(base)
      base.class_eval do
        include Butterfli::Regulation::Rule

        permits_if do |rule, item|
          if rule.effective_rate && last_time = rule.fact(:last_time).from(rule, item)
            (Time.now-last_time) > rule.seconds_per
          else
            true
          end
        end
      end
    end
  end
end