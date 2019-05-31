require "./broolik/*"

module Broolik
  VERSION = "0.1.0"

  def self.client(endpoint = "https://broolik.tk") : Client
    Client.new(endpoint)
  end
end
