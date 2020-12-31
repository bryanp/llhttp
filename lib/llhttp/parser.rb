# frozen_string_literal: true

require "forwardable"

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
  #   * `LLHttp::Parser#method` returns the method of the current response.
  #   * `LLHttp::Parser#status_code` returns the status code of the current response.
  #   * `LLHttp::Parser#keep_alive?` returns `true` if there might be more messages.
  #
  # Finishing
  #
  #   Call `LLHttp::Parser#finish` when processing is complete for the current request or response.
  #
  class Parser
    extend Forwardable
    def_delegators :@instance, :parse, :<<, :content_length, :status_code, :keep_alive?

    LLHTTP_TYPES = {both: 0, request: 1, response: 2}.freeze

    # [public] The parser type; one of: `:both`, `:request`, or `:response`.
    #
    attr_reader :type

    def initialize(delegate, type: :both)
      @type, @delegate = type.to_sym, delegate
      @instance = Instance.new(nil, LLHTTP_TYPES.fetch(@type), @delegate)
    end

    def finish
      LLHttp.llhttp_finish(@instance)
    end

    def method
      @instance.request_method
    end
  end
end
