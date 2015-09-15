require 'spec_helper'

describe Butterfli::Configuration::Regulation::Policy do
  it { expect(Butterfli::Configuration::Regulation::Policy <= Butterfli::Configuration::Regulation::RuleHolder).to be true }
end