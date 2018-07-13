
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aws_ssh_key/version"

Gem::Specification.new do |spec|
  spec.name          = "aws_ssh_key"
  spec.version       = AwsSshKey::VERSION
  spec.authors       = ["kief "]
  spec.email         = ["kmorris@thoughtworks.com"]

  spec.summary       = 'Library to manage ssh keys stored in AWS encrypted parameter store'
  spec.description   = 'Library to manage ssh keys stored in AWS encrypted parameter store'
  spec.homepage      = 'https://github.com/cloudspinners/aws_ssh_key'
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk', '~> 2.11'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
