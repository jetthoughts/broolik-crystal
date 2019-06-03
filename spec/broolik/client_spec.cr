require "../spec_helper"

describe Broolik::Client do
  describe "#create_link" do
    context "when 404 status is returned" do
      it "an exception should be raised" do
        expect_raises(Broolik::Error) do
          WebMock.wrap do
            WebMock.stub(:any, "https://broolik.tk/api/v1/links.json")
              .to_return(status: 404)

            Broolik.client.create_link
          end
        end
      end
    end

    it "creates remote link and return details" do
      WebMock.stub(:post, "https://broolik.tk/api/v1/links.json")
        .to_return(status: 201, body: <<-LINK_RAW_RESPONSE)
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

      link = Broolik.client.create_link({"url" => "http://jetthoughts.com"})

      link.success?.should be_true
    end
  end

  describe "#find_link" do
    it "returns links validation details" do
      WebMock.stub(:get, "https://broolik.tk/api/v1/links/uniq-uuid-as-string.json")
        .to_return(status: 201, body: <<-LINK_RAW_RESPONSE)
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

      found_link = Broolik.client.find_link("uniq-uuid-as-string")

      found_link.success?.should be_true
    end
  end

  describe "#create_batch" do
    it "creates remote link and return details" do
      WebMock.stub(:post, "https://broolik.tk/api/v1/batches.json")
        .to_return(status: 201, body: <<-LINK_RAW_RESPONSE)
					{
						"id": "8e0eed26-20fb-4370-a177-11ecf3c136d6",
						"updated_at": "2019-05-31T15:36:47.137Z",
						"status": "created"
					}
			LINK_RAW_RESPONSE

      batch = Broolik.client.create_batch({"file" => "./spec/fixtures/urls_example.csv"})

      batch.created?.should be_true
    end
  end

  describe "#find_batch" do
    it "creates remote link and return details" do
      WebMock.stub(:get, "https://broolik.tk/api/v1/batches/batch-uuid.json")
        .to_return(status: 201, body: <<-LINK_RAW_RESPONSE)
					{
						"id": "8e0eed26-20fb-4370-a177-11ecf3c136d6",
						"updated_at": "2019-05-31T15:36:47.137Z",
						"status": "links_attached"
					}
			LINK_RAW_RESPONSE

      batch = Broolik.client.find_batch("batch-uuid")

      batch.links_attached?.should be_true
    end
  end
end
