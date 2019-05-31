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
