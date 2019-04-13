# Gamefic Standard

The standard library for the Gamefic interactive fiction framework.

Gamefic Standard provides common useful components for adventure games. [Inform](http://inform7.com/)
developers should find it similar to Inform's Standard Rules. It defines common
components like Rooms and Characters, along with in-game commands like `GO`,
`GET`, and `DROP` to enable basic interactivity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gamefic-standard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamefic-standard

## Usage

Require the library in your game scripts:

```ruby
require 'gamefic'
require 'gamefic-standard'

Gamefic.script do
  @office = make Room, name: 'office'
  @desk = make Fixture, name: 'desk', parent: @office

  introduction do |actor|
    actor.parent = @office
    actor.tell "You're in an office."
  end
end
```

Go to the [Gamefic website](https://gamefic.com) or the [SDK repo](https://github.com/castwide/gamefic-sdk)
for more information about using Gamefic.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gamefic-standard.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
