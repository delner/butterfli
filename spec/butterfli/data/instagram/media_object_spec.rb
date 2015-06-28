require 'spec_helper'

describe Butterfli::Data::Instagram::MediaObject do 
  # TODO: Replace with Olfactory template
  let(:sample_object) do
    { "attribution" =>  nil,
      "tags" => ["olblueeyes","rubyrose","motherhood"],
      "location" => {"latitude" => 40.784478333,"longitude" => -73.971396667},
      "comments" => {
        "count" => 1,
        "data" => [
          { "created_time" => "1279332030",
            "text" => "Love the sign here",
            "from" => {
              "username" => "mikeyk",
              "full_name" => "Mikey Krieger",
              "id" => "4",
              "profile_picture" => "http://distillery.s3.amazonaws.com/profiles/profile_1242695_75sq_1293915800.jpg"},
            "id" => "8" }]},
      "filter" => "Normal",
      "created_time" => "1435437184",
      "link" => "https://instagram.com/p/4cjY-nKByk/",
      "likes" =>  {
        "count" => 1,
        "data" =>  [
          { "username" => "stefanjamesofficial",
            "profile_picture" => "https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-19/11357550_448421468663723_1451399633_a.jpg",
            "id" => "1523313214",
            "full_name" => "Stefan James u2122 u24e5"}]},
      "images" =>  {
        "low_resolution" =>  {
          "url" => "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s320x320/e15/11426410_1611694282448373_1959871083_n.jpg",
          "width" => 320,
          "height" => 320},
        "thumbnail" =>  {
          "url" => "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s150x150/e15/11426410_1611694282448373_1959871083_n.jpg",
          "width" => 150,
          "height" => 150},
        "standard_resolution" =>  {
          "url" => "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11426410_1611694282448373_1959871083_n.jpg",
          "width" => 640,
          "height" => 640}},
      "users_in_photo" => [],
      "caption" =>  {
        "created_time" => "1435437184",
        "text" => "14 weeks! It's hard to remember life before #rubyrose but it's safe to say it's so much sweeter now. #olblueeyes #motherhood @mattsemrick",
        "from" =>  {
          "username" => "mich1112",
          "profile_picture" => "https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xpa1/t51.2885-19/10467926_1436033379996659_2075234333_a.jpg",
          "id" => "214282566",
          "full_name" => "mich1112"},
        "id" => "1016843266981109206"},
      "type" => "image",
      "id" => "1016843264003153060_214282566",
      "user" =>  {
        "username" => "mich1112",
        "profile_picture" => "https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xpa1/t51.2885-19/10467926_1436033379996659_2075234333_a.jpg",
        "id" => "214282566",
        "full_name" => "mich1112"
      }
    }
  end

  context "created from a media object" do
    it { expect(Butterfli::Data::Instagram::MediaObject.new(sample_object)).to eq(sample_object) }
  end

 
  describe "#transform" do
    subject { Butterfli::Data::Instagram::MediaObject.new(sample_object).transform }
    it { expect(subject).to be_a(Butterfli::Story) }

    context "when given basic data" do
      it { expect(subject.source).to eq('instagram') }
      it { expect(subject.type).to eq('image') }
      it { expect(subject.created_date).not_to be_nil } # TODO: Assert correct content
    end
    context "when given references" do
      subject { super().references }
      it { expect(subject.source_uri).not_to be_nil } # TODO: Assert correct content
    end
    context "when given images" do
      subject { super().images }
      it { expect(subject.thumbnail).to be_a(Butterfli::Imageable::Image) } # TODO: Assert correct content
      it { expect(subject.small).to be_a(Butterfli::Imageable::Image) } # TODO: Assert correct content
      it { expect(subject.full).to be_a(Butterfli::Imageable::Image) } # TODO: Assert correct content
    end
    context "when given an author" do
      subject { super().author }
      it { expect(subject.username).not_to be_nil } # TODO: Assert correct content
      it { expect(subject.name).not_to be_nil } # TODO: Assert correct content
    end
    context "when given text content" do
      subject { super().text }
      it { expect(subject.title).to be_nil } # Not available.
      it { expect(subject.body).not_to be_nil } # TODO: Assert correct content
    end
    context "when given tags" do
      subject { super().tags }
      it { expect(subject).not_to be_empty } # TODO: Assert correct content
    end
    context "when given comments" do
      subject { super().comments }
      it { expect(subject).not_to be_empty } # TODO: Assert correct content
    end
    context "when given shares" do
      subject { super().shares }
      it { expect(subject).to be_empty } # Not available.
    end
    context "when given likes" do
      subject { super().likes }
      it { expect(subject).not_to be_empty } # TODO: Assert correct content
    end
    context "when given a location" do
      subject { super().location }
      it { expect(subject.lat).not_to be_nil } # TODO: Assert correct content
      it { expect(subject.lng).not_to be_nil } # TODO: Assert correct content
    end
  end
end