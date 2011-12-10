$:.unshift "lib"
require "audiosocket/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Audiosocket"]
  gem.email         = ["tech@audiosocket.com"]
  gem.description   = "An authentication client for the Audiosocket API."
  gem.summary       = "Helps authenticate users and generate Audiosocket API tokens."

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename f }
  gem.files         = `git ls-files`.split "\n"
  gem.homepage      = "https://github.com/audiosocket/ruby-client"
  gem.name          = "audiosocket"
  gem.require_paths = ["lib"]
  gem.test_files    = `git ls-files -- test/*`.split "\n"
  gem.version       = Audiosocket::VERSION

  gem.required_ruby_version = ">= 1.9.2"

  gem.add_dependency "faraday", "~> 0.7"
end
