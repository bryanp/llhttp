# frozen_string_literal: true

module LLHttp
  # Wraps an llhttp context for parsing http requests and responses.
  #
  # = Finishing
  #
  # Call `LLHttp::Parser#finish` when processing is complete for the current request or response.
  #
  # = Introspection
  #
  # `LLHttp::Parser#keep_alive?` returns `true` if there might be any other messages following the last that was successfuly parsed.
  #
  class Parser
    LLHTTP_TYPES = {both: 0, request: 1, response: 2}.freeze

    attr_reader :type

    def initialize(delegate, type: :both)
      @type, @delegate = type.to_sym, delegate

      llhttp_init(LLHTTP_TYPES.fetch(@type))
    end
  end
end

require_relative "llhttp_ext"
