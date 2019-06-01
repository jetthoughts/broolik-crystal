require "../spec_helper"

describe Broolik::Batch do
  describe "#from_json" do
    context "from response after schedule" do
      it "supports created satus" do
        batch = Broolik::Batch.from_json(<<-LINK_RAW_RESPONSE)
        {
          "id": "8e0eed26-20fb-4370-a177-11ecf3c136d6",
          "updated_at": "2019-05-31T15:36:47.137Z",
          "status": "created"
        }
        LINK_RAW_RESPONSE

        batch.created?.should be_true
      end
    end

    context "from response on complete checks" do
      it "supports report_complete satus" do
        batch = Broolik::Batch.from_json(<<-LINK_RAW_RESPONSE)
        {
          "id": "8e0eed26-20fb-4370-a177-11ecf3c136d6",
          "updated_at": "2019-05-31T15:36:47.137Z",
          "status": "report_complete",
          "links_report": "https://example.com/test.csv"
        }
        LINK_RAW_RESPONSE

        batch.report_complete?.should be_true
        batch.links_report.should eq URI.parse("https://example.com/test.csv").to_s
      end
    end
  end
end
