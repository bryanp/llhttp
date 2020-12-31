# frozen_string_literal: true

require File.expand_path("../lib/llhttp/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "llhttp"
  spec.version = LLHttp::VERSION
  spec.summary = "Ruby bindings for llhttp."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@metabahn.com"
  spec.homepage = "https://github.com/metabahn/llhttp/"

  spec.required_ruby_version = ">= 2.5.0"

  spec.license = "MIT"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*", "ext/**/*"]
  spec.require_path = "lib"

  spec.extensions = %w[ext/llhttp/extconf.rb]
end
