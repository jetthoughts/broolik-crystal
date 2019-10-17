require "./broolik/*"

module Broolik
  VERSION = "0.1.0"

  def self.client(endpoint = "https://broolik.ml") : Client
    Client.new(endpoint)
  end
end
