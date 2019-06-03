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

      response = upload_links_as_csv(batches_url, batch_attrs)

      handle_response response do
        Broolik::Batch.from_json(response.body)
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

    private def upload_links_as_csv(batches_url : String, batch_attrs : Hash(String, String))
      IO.pipe do |reader, writer|
        channel = Channel(String).new(1)

        spawn do
          HTTP::FormData.build(writer) do |formdata|
            channel.send(formdata.content_type)

            if batch_attrs["file"]?
              File.open(batch_attrs["file"]) do |file|
                metadata = HTTP::FormData::FileMetadata.new(filename: File.basename(file.path))
                headers = HTTP::Headers{"Content-Type" => "text/csv"}
                formdata.file("batch[file]", file, metadata, headers)
              end
            end
          end

          writer.close
        end

        headers = HTTP::Headers{"Content-Type" => channel.receive}
        HTTP::Client.post(batches_url, body: reader, headers: headers)
      end
    end
  end
end
