require 'spec_helper'

describe Butterfli do
  context "with processing" do
    it { expect(subject).to respond_to(:processor) }
  end
end