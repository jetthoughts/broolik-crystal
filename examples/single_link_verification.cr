require "../src/broolik"

client = Broolik.client

link = client.create_link({
  # "country" => "UKR",
  "url"    => "http://jetthoughts.com",
  "device" => "iphone",
})

puts "Link validation status for http://jetthoughts.com is: #{link.status}"

client.close
