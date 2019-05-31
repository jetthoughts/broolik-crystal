require "./spec_helper"

describe Broolik do
  describe ".client" do
    it "use https://broolik.tk/ as default endpoint" do
      Broolik.client.endpoint.should eq "https://broolik.tk"
    end
  end
end
