require "../src/broolik"

client = Broolik.client("https://broolik.tk")

link = client.create_link({
# "country" => "UKR",
  "url"     => "http://jetthoughts.com",
  "device"  => "iphone",
})

puts "Link validation status for http://jetthoughts.com is: #{link.status}"

client.close
