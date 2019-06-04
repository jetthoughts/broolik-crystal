require "json"
require "http"

module Broolik
  class Error < Exception; end

  class Client
    property endpoint

    @base_url : URI

    def initialize(@endpoint : String)
      @base_url = URI.parse(@endpoint).normalize
      @http_client = HTTP::Client.new @base_url
    end

    def close
      @http_client.close
    end

    def create_link(link_attrs : Hash(String, String) = {} of String => String)
      links_url = @base_url.to_s + "/api/v1/links.json"

      response = @http_client.post("/api/v1/links.json", form: link_attrs)

      handle_response(response) do |res|
        Link.from_json(res)
      end
    end

    def find_link(id)
      link_url = @base_url.to_s + "/api/v1/links/#{id}.json"

      response = @http_client.get(link_url)

      handle_response(response) do |res|
        Link.from_json(res)
      end
    end

    def create_batch(*links_attrs : Hash(String, String))
      batches_url = @base_url.to_s + "/api/v1/batches.json"

      params = HTTP::Params.build do |params|
        links_attrs.each do |link_attrs|
          link_attrs.each do |(k, v)|
            params.add "batch[links][][#{k}]", v
          end
        end
      end

      response = @http_client.post(batches_url, form: params)

      handle_response response do
        Broolik::Batch.from_json(response.body)
      end
    end

    def create_batch_with_file(file_path : String)
      batches_url = @base_url.to_s + "/api/v1/batches.json"

      response = upload_links_as_csv(batches_url, csv_file_path: file_path)

      handle_response response do
        Broolik::Batch.from_json(response.body)
      end
    end

    def find_batch(id)
      batch_url = @base_url.to_s + "/api/v1/batches/#{id}.json"

      response = @http_client.get(batch_url)

      handle_response response do
        Broolik::Batch.from_json(response.body)
      end
    end

    private def handle_response(response, &block)
      case response.status_code
      when (200...300)
        yield response.body
      else
        raise Error.new(response.status_code.to_s)
      end
    end

    private def upload_links_as_csv(batches_url : String, *, csv_file_path : String | Nil = nil, links_attrs : Hash(String, String) | Nil = nil)
      IO.pipe do |reader, writer|
        channel = Channel(String).new(1)

        spawn do
          HTTP::FormData.build(writer) do |formdata|
            channel.send(formdata.content_type)

            File.open(csv_file_path) do |file|
              metadata = HTTP::FormData::FileMetadata.new(filename: File.basename(file.path))
              headers = HTTP::Headers{"Content-Type" => "text/csv"}
              formdata.file("batch[file]", file, metadata, headers)
            end
          end

          writer.close
        end

        headers = HTTP::Headers{"Content-Type" => channel.receive}
        @http_client.post(batches_url, body: reader, headers: headers)
      end
    end
  end
end
