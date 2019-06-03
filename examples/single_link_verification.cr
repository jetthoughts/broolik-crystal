require "../src/broolik"

client = Broolik.client("http://lvh.me:3000")

link = client.create_link({
  "url"     => "http://jetthoughts.com",
  "device"  => "iphone",
  "country" => "UKR",
})

puts "Link validation status is: #{link.status}"

batch = client.create_batch({"file" => "spec/fixtures/urls_example.csv"})
puts "Batch is #{batch.status}"

until batch.report_completed?
  sleep 15

  batch = client.find_batch(batch.id)

  puts "Batch is #{batch.status}"
end

puts "Report located on #{batch.links_report}"

HTTP::Client.get(batch.links_report.not_nil!) do |response|
  puts response.body
end
