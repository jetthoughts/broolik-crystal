require "../src/broolik"

client = Broolik.client("https://broolik.tk")

link = client.create_link({
  "url"     => "http://jetthoughts.com",
  "device"  => "iphone",
  "country" => "UKR",
})

puts "Link validation status for http://jetthoughts.com is: #{link.status}"

client.close
