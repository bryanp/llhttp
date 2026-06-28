# frozen_string_literal: true

require "pathname" # standard:disable Lint/RedundantRequireStatement -- needed on Ruby < 3.x where Pathname isn't autoloaded

initializers = Pathname.new(File.expand_path("../initializers", __FILE__))

if initializers.directory?
  initializers.glob("*.rb") do |file|
    load(file)
  end
end
