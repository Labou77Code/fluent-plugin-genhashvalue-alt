# Fluent::Plugin::GenHashValue-alt

fluentd filter plugin.
generate hash(md5/sha1/sha256/sha512) value. It forks from GenHashValue with 2 differences:
- murmurhash algorithm is not supported to ease deployment on windows machine (no need to build native plug)
- possibility to hash the whole record, not only a combination of keys

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-genhashvalue-alt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-genhashvalue-alt


## Configuration

Example if you want to compute hash based on 2 keys (e.g key1 and key2) of your record:

    <filter foo.**>
      type genhashvalue-alt

      keys key1,key2
      hash_type md5    # md5/sha1/sha256/sha512
      base64_enc true
      base91_enc false
      set_key _hash
      separator _
      inc_time_as_key true
      inc_tag_as_key false
    </filter>

Example if you want to compute hash on the entire record:

    <filter foo.**>
      type genhashvalue-alt

      use_entire_record true
      hash_type md5    # md5/sha1/sha256/sha512
      base64_enc true
      base91_enc false
      set_key _hash
      separator _
      inc_time_as_key true
      inc_tag_as_key false
    </filter>
    


Input:

    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test
    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test
    root@112133c12ee3:~/fluentd# echo '{"type":"log","descr":"description..."}' | ./bin/fluent-cat foo.test

Filterd:

    2016-10-23 15:06:05 +0000 foo.test: {"type":"log","descr":"description...","_hash":"/B3pc4NBk6Z9Ph89k+ZL4Q=="}
    2016-10-23 15:06:22 +0000 foo.test: {"type":"log","descr":"description...","_hash":"IgB25wc3M0QJfk0KteYygQ=="}
    2016-10-23 15:06:37 +0000 foo.test: {"type":"log","descr":"description...","_hash":"vvDF6eWyX5Sc01AVw8P6Cw=="}


## Development

After checking out the repo, run first `ridk install` if your ruby has no dev kit installed yet. Then run `bundle install` to install dependencies. Then, run `rake test` to run the tests. 

To release a new version, update the version number in `.gemspec`, and then create a git tag for the version, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Debug unit test
Run `gem install ruby-debug-ide` and `gem install debase`.
Then go to Debug tab in VS code and run the Test::Unit config. You should be able to reach your breakpoint

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Labou77Code/fluent-plugin-genhashvalue-alt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
