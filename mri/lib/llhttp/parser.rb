# frozen_string_literal: true

module LLHttp
  # [public] Wraps an llhttp context for parsing http requests and responses.
  #
  #   class Delegate < LLHttp::Delegate
  #     def on_message_begin
  #       ...
  #     end
  #
  #     ...
  #   end
  #
  #   parser = LLHttp::Parser.new(Delegate.new, type: :request)
  #   parser << "GET / HTTP/1.1\r\n\r\n"
  #   parser.finish
  #
  #   ...
  #
  # Introspection
  #
  #   * `LLHttp::Parser#content_length` returns the content length of the current request.
  #   * `LLHttp::Parser#method_name` returns the method name of the current response.
  #   * `LLHttp::Parser#status_code` returns the status code of the current response.
  #   * `LLHttp::Parser#http_major` returns the major http version of the current request/response.
  #   * `LLHttp::Parser#http_minor` returns the minor http version of the current request/response.
  #   * `LLHttp::Parser#keep_alive?` returns `true` if there might be more messages.
  #
  # Finishing
  #
  #   Call `LLHttp::Parser#finish` when processing is complete for the current request or response.
  #
  # Resetting
  #
  #   Call `LLHttp::Parser#reset` to reset the parser for the next request or response.
  #
  class Parser
    LLHTTP_TYPES = {both: 0, request: 1, response: 2}.freeze

    # [public] The parser type; one of: `both`, `request`, or `response`.
    #
    attr_reader :type

    def initialize(delegate, type: :both)
      @type, @delegate = type.to_sym, delegate

      llhttp_init(LLHTTP_TYPES.fetch(@type))
    end
  end
end

require "llhttp_ext"
