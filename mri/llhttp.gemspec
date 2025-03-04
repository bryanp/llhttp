# frozen_string_literal: true

require File.expand_path("../lib/llhttp/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "llhttp"
  spec.version = LLHttp::VERSION
  spec.summary = "Ruby bindings for llhttp."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@bryanp.org"
  spec.homepage = "https://github.com/bryanp/llhttp/"

  spec.required_ruby_version = ">= 3.1"

  spec.license = "MPL-2.0"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*", "ext/**/*"]
  spec.require_path = "lib"

  spec.extensions = %w[ext/llhttp/extconf.rb]
end
