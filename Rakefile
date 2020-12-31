# frozen_string_literal: true

require "fileutils"
require "rake/extensiontask"

Rake::ExtensionTask.new "llhttp_ext" do |ext|
  ext.ext_dir = "ext/llhttp"
end

task test: :compile do
  unless system "bundle exec rspec"
    exit $?.exitstatus
  end
end

task :clean do
  [
    "./lib/llhttp_ext.bundle"
  ].each do |file|
    next unless File.exist?(file)

    FileUtils.rm(file)
  end
end

task build: %i[test clean] do
  system "gem build llhttp.gemspec"
end
