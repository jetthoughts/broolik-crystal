require "json"
require "http/client"

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

      handle_response response
    end

    def find_link(id)
      link_url = @base_url.to_s + "/api/v1/links/#{id}.json"

      response = HTTP::Client.get(link_url)

      handle_response response
    end

    private def handle_response(response)
      case response.status_code
      when (200...300)
        Broolik::Link.from_json(response.body)
      else
        raise Error.new(response.to_s)
      end
    end
  end
end
