# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'animated_gif_detector/version'

Gem::Specification.new do |spec|
  spec.name          = "animated_gif_detector"
  spec.version       = AnimatedGifDetector::VERSION
  spec.authors       = ["Bradford Folkens"]
  spec.email         = ["bfolkens@gmail.com"]

  spec.summary       = %q{Animated GIF detection in pure ruby}
  spec.description   = %q{Reads a stream and determines if it's an animated GIF}
  spec.homepage      = "https://github.com/bfolkens/ruby-animated-gif-detector"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
