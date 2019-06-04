require "../src/broolik"

def watch_for_report(client, batch)
  until batch.report_completed?
    sleep 15

    batch = client.find_batch(batch.id)

    puts "Batch is #{batch.status}"
  end

  puts "Report located on #{batch.links_report}"

  sleep 1

  unless batch.links_report.nil?
    puts "Verification report:"
    HTTP::Client.get(batch.links_report.as(String)) do |response|
      puts response.body_io.gets_to_end
    end
    puts "=" * 10
  end
end

client = Broolik.client("https://broolik.tk")

puts "Schedule bulk links verifications"
batch = client.create_batch(
  {"url" => "http://jetthoughts.com"},
  {"url" => "http://jtway.co", "device" => "iphone"}
)
puts "Batch is #{batch.status}"

watch_for_report(client, batch)

puts "Schedule bulk links verifications with file"
batch = client.create_batch_with_file("examples/urls_example.csv")
puts "Batch is #{batch.status}"

watch_for_report(client, batch)

client.close
