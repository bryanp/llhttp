# frozen_string_literal: true

require_relative "../shared"

benchmark

# require "ruby-prof"

# delegate = LLHttp::Delegate.new
# instance = LLHttp::Parser.new(delegate, type: :request)

# result = RubyProf.profile {
#   1_000_000.times do
#     parse(instance)
#     instance.finish
#   end
# }

# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT, {})
