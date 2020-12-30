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
  #   * `LLHttp::Parser#method` returns the method of the current response.
  #   * `LLHttp::Parser#status_code` returns the status code of the current response.
  #   * `LLHttp::Parser#keep_alive?` returns `true` if there might be more messages.
  #
  # Finishing
  #
  #   Call `LLHttp::Parser#finish` when processing is complete for the current request or response.
  #
  class Parser
    LLHTTP_TYPES = {both: 0, request: 1, response: 2}.freeze

    # [public] The parser type; one of: `both`, `request`, or `response`.
    #
    attr_reader :type

    def initialize(delegate, type: :both)
      @type, @delegate = type.to_sym, delegate
      @instance = Instance.new(nil, LLHTTP_TYPES.fetch(@type), @delegate)
    end

    def finish
      LLHttp.llhttp_finish(@instance)
    end

    def parse(data)
      errno = LLHttp.llhttp_execute(@instance, data, data.length)
      raise build_error(errno) if errno > 0
    end
    alias_method :<<, :parse

    def content_length
      @instance[:content_length]
    end

    def method
      LLHttp.llhttp_method_name(@instance[:method]).read_string
    end

    def status_code
      @instance[:status_code]
    end

    def keep_alive?
      LLHttp.llhttp_should_keep_alive(@instance) == 1
    end

    private def build_error(errno)
      Error.new("Error Parsing data: #{LLHttp.llhttp_errno_name(errno).read_string} #{LLHttp.llhttp_get_error_reason(@instance).read_string}")
    end
  end
end
