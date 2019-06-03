require "../src/broolik"

client = Broolik.client("http://lvh.me:3000")

link = client.create_link({
  "url"     => "http://jetthoughts.com",
  "device"  => "iphone",
  "country" => "UKR",
})

puts "Link validation status is: #{link.status}"

