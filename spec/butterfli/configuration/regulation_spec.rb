require 'spec_helper'

describe Butterfli::Configuration::Regulation do
  it { expect(Butterfli::Configuration::Regulation <= Butterfli::Configuration::Regulation::PolicyHolder).to be true }
end