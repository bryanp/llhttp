# frozen_string_literal: true

require File.expand_path("../lib/llhttp/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "llhttp-ffi"
  spec.version = LLHttp::VERSION
  spec.summary = "Ruby FFI bindings for llhttp."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@metabahn.com"
  spec.homepage = "https://github.com/metabahn/llhttp/"

  spec.required_ruby_version = ">= 2.6.7"

  spec.license = "MPL-2.0"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*", "ext/**/*"]
  spec.require_path = "lib"

  spec.extensions = %w[ext/Rakefile]

  spec.add_dependency "ffi-compiler", "~> 1.0"
  spec.add_dependency "rake", "~> 13.0"
end
