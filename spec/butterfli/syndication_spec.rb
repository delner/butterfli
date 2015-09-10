require 'spec_helper'

describe Butterfli do
  context "with syndication" do
    it { expect(subject).to respond_to(:subscribe) }
    it { expect(subject).to respond_to(:syndicate) }
  end
end