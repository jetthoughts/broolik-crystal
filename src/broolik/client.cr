require "json"
require "http"

module Broolik
  class Error < Exception; end

  class Client
    property endpoint

    @base_url : URI

    def initialize(@endpoint : String)
      @base_url = URI.parse(@endpoint).normalize
    end

    def create_link(link_attrs : Hash(String, String) = {} of String => String)
      links_url = @base_url.to_s + "/api/v1/links.json"

      response = HTTP::Client.post(links_url, form: link_attrs)

      handle_response(response) do |res|
				Link.from_json(res)
			end
    end

    def find_link(id)
      link_url = @base_url.to_s + "/api/v1/links/#{id}.json"

      response = HTTP::Client.get(link_url)

      handle_response(response) do |res|
				Link.from_json(res)
			end
    end

    def create_batch(batch_attrs)
      batches_url = @base_url.to_s + "/api/v1/batches.json"

			IO.pipe do |reader, writer|
				channel = Channel(String).new(1)

				spawn do
					HTTP::FormData.build(writer) do |formdata|
						channel.send(formdata.content_type)

						formdata.field("name", "foo")
						if batch_attrs["file"]
							File.open(batch_attrs["file"]) do |file|
								metadata = HTTP::FormData::FileMetadata.new(filename: "foo.png")
								headers = HTTP::Headers{"Content-Type" => "image/png"}
								formdata.file("file", file, metadata, headers)
							end
						end
					end

					writer.close
				end

				headers = HTTP::Headers{"Content-Type" => channel.receive}
				response = HTTP::Client.post(batches_url, body: reader, headers: headers)

				# response = HTTP::Client.post(batches_url, params: batch_upload_params)

				handle_response response do
					Broolik::Batch.from_json(response.body)
				end
			end
		end

		def find_batch(id)
			batch_url = @base_url.to_s + "/api/v1/batches/#{id}.json"

			response = HTTP::Client.get(batch_url)

				handle_response response do
					Broolik::Batch.from_json(response.body)
				end
		end

		private def handle_response(response, &block)
			case response.status_code
			when (200...300)
				yield response.body
			else
				raise Error.new(response.to_s)
			end
		end
	end
end
