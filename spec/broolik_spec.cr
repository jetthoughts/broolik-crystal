require "./spec_helper"

describe Broolik do
  describe ".client" do
    it "use https://broolik.ml/ as default endpoint" do
      Broolik.client.endpoint.should eq "https://broolik.ml"
    end
  end
end
