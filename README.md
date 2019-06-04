[![CircleCI](https://circleci.com/gh/jetthoughts/broolik-crystal/tree/master.svg?style=svg)](https://circleci.com/gh/jetthoughts/broolik-crystal/tree/master)
[![Travis CI](https://travis-ci.org/jetthoughts/broolik-crystal.svg?branch=master)](https://travis-ci.org/jetthoughts/broolik-crystal)

# Broolik: Affiliate Links Checker for Crystal

TODO: Write a description here

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     broolik:
       github: jetthoughts/broolik-crystal
   ```

2. Run `shards install`

## Usage

1. Single link real-time verification:

```crystal
require "broolik"

client = Broolik.client

link = client.create_link({
  "url" => "http://jetthoughts.com",
  "device" => "iphone",
  "country" => "UKR"
})

puts "Link validation status is: #{link.status}"

link.redirects.each do |redirect|
  puts "Following '#{redirect.url}' got '#{redirect.status_code}'
end

client.close
```

2. Schedule bulk verification:

```crystal
require "broolik"

client = Broolik.client

batch = client.create_batch(
  {
    "url" => "http://jetthoughts.com",
    "device" => "iphone",
    "country" => "UKR"
  },
  {
    "url" => "http://jtway.co",
    "device" => "android",
    "country" => "USA"
  }
)

puts "Batch validation state is: #{batch.status}"

until batch.report_completed?
  sleep 5 * 60 # 5 minutes

  # Poll batch result each 5 minutes
  batch = client.find_batch(batch.id)
  puts "Batch validation state is: #{batch.status}"
end

# Show batch report content
unless batch.links_report.nil?
  puts "Verification report:"
  HTTP::Client.get(batch.links_report.as(String)) do |response|
    puts response.body_io.gets_to_end
  end
  puts "=" * 10
end

client.close
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/broolik-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Paul Keen](https://github.com/pftg) - creator and maintainer
