require 'butterfli/configuration/regulation/throttle'
require 'butterfli/configuration/regulation/throttles'
require 'butterfli/configuration/regulation/rule_holder'

require 'butterfli/configuration/regulation/policy'
require 'butterfli/configuration/regulation/policies'
require 'butterfli/configuration/regulation/policy_holder'

module Butterfli::Configuration::Regulation
  include Butterfli::Configuration::Regulation::PolicyHolder

  def self.included(base)
    base.class_eval { include Butterfli::Configuration::Regulation::PolicyHolder }
  end
end