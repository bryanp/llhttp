# frozen_string_literal: true

require "fileutils"

task :compile do
  system "cd ext && bundle exec rake"
end

task test: :compile do
  unless system "bundle exec rspec"
    exit $?.exitstatus
  end
end

task :clean do
  [
    "./lib/llhttp/llhttp_ext.bundle"
  ].each do |file|
    FileUtils.rm(file)
  end
end

task build: %i[test clean] do
  system "gem build llhttp.gemspec"
end
