# frozen_string_literal: true

require "rake/extensiontask"

Rake::ExtensionTask.new "llhttp_ext" do |ext|
  ext.ext_dir = "ext/llhttp"
  ext.lib_dir = "lib/llhttp"
end

task test: :compile do
  unless system "bundle exec rspec"
    exit $?.exitstatus
  end
end
