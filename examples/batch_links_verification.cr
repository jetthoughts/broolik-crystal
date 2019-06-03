require "../src/broolik"

def watch_for_report(client, batch)
  until batch.report_completed?
    sleep 15

    batch = client.find_batch(batch.id)

    puts "Batch is #{batch.status}"
  end

  puts "Report located on #{batch.links_report}"

  HTTP::Client.get(batch.links_report.not_nil!) do |response|
    puts response.body
  end
end

client = Broolik.client("https://broolik.tk")

batch = client.create_batch({"file" => "spec/fixtures/urls_example.csv"})
puts "Batch is #{batch.status}"

watch_for_report(client, batch)

batch = client.create_batch({"links[][url]" => "http://jetthoughts.com"})
puts "Batch is #{batch.status}"

watch_for_report(client, batch)
