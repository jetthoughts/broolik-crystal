require "../spec_helper"

describe Broolik::Link do
  describe "#from_json" do
    it "supports in_progress satus" do
      link = Broolik::Link.from_json(<<-LINK_RAW_RESPONSE)
      {
        "id": "uniq-uuid-as-string",
        "error": "Unknown Type: string,null",
        "status": "in_progress",
        "device": "iphone",
        "redirects": [
          {
            "url": "http://jetthoughts.com",
            "status_code": 301
          }
        ],
        "url": "http://jetthoughts.com",
        "last_url": "https://www.jetthoughts.com/",
        "country": "USA",
        "response_code": 0,
        "updated_at": "2019-05-12T13:35:12.825Z"
      }
      LINK_RAW_RESPONSE

      link.in_progress?.should be_true
    end

    it "loads link details" do
      link = Broolik::Link.from_json(<<-LINK_RAW_RESPONSE)
      {
        "id": "uniq-uuid-as-string",
        "error": "Unknown Type: string,null",
        "status": "success",
        "device": "iphone",
        "redirects": [
          {
            "url": "http://jetthoughts.com",
            "status_code": 301
          }
        ],
        "url": "http://jetthoughts.com",
        "last_url": "https://www.jetthoughts.com/",
        "country": "USA",
        "response_code": 0,
        "updated_at": "2019-05-12T13:35:12.825Z"
      }
      LINK_RAW_RESPONSE

      link.success?.should be_true
      link.redirects.not_nil!.empty?.should be_false
    end
  end
end
