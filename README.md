[![Build Status](https://travis-ci.org/bfolkens/ruby-animated-gif-detector.svg?branch=master)](https://travis-ci.org/bfolkens/ruby-animated-gif-detector)

# AnimatedGifDetector

A simple utility to determine if a GIF is animated, and how many frames it contains.  Only 2 frames are needed to determine if the GIF is "animated", so the user has the option to specify an option to return immediately or keep counting frames.  Designed for use on a stream to avoid unnecessary memory usage.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'animated_gif_detector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install animated_gif_detector

## Usage

One-liner:

```ruby
AnimatedGifDetector.new(File.open('your_image.gif', 'rb')).animated?
```

Customizable:

```ruby
io = File.open('your_image.gif', 'rb')
detector = AnimatedGifDetector.new(io, terminate_after: false)
detector.animated? # true
detector.frames # 3
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bfolkens/animated_gif_detector.
