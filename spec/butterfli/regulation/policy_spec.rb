require 'spec_helper'

describe Butterfli::Regulation::Policy do
  it { expect(Butterfli::Regulation::Policy <= Butterfli::Regulation::RuleHolder).to be true }
end