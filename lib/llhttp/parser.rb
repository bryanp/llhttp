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
  #   * `LLHttp::Parser#method_name` returns the method of the current response.
  #   * `LLHttp::Parser#status_code` returns the status code of the current response.
  #   * `LLHttp::Parser#keep_alive?` returns `true` if there might be more messages.
  #
  # Finishing
  #
  #   Call `LLHttp::Parser#finish` when processing is complete for the current request or response.
  #
  class Parser
    LLHTTP_TYPES = {both: 0, request: 1, response: 2}.freeze

    # [public] The parser type; one of: `:both`, `:request`, or `:response`.
    #
    attr_reader :type

    def initialize(delegate, type: :both)
      @type, @delegate = type.to_sym, delegate

      @callbacks = Callbacks.new
      @callbacks[:on_message_begin] = delegate.method(:on_message_begin).to_proc
      @callbacks[:on_url] = method(:on_url).to_proc
      @callbacks[:on_status] = method(:on_status).to_proc
      @callbacks[:on_header_field] = method(:on_header_field).to_proc
      @callbacks[:on_header_value] = method(:on_header_value).to_proc
      @callbacks[:on_headers_complete] = delegate.method(:on_headers_complete).to_proc
      @callbacks[:on_body] = method(:on_body).to_proc
      @callbacks[:on_message_complete] = delegate.method(:on_message_complete).to_proc
      @callbacks[:on_chunk_header] = delegate.method(:on_chunk_header).to_proc
      @callbacks[:on_chunk_complete] = delegate.method(:on_chunk_complete).to_proc

      @pointer = LLHttp.rb_llhttp_init(LLHTTP_TYPES.fetch(@type), @callbacks)
    end

    def parse(data)
      errno = LLHttp.llhttp_execute(@pointer, data, data.length)
      raise build_error(errno) if errno > 0
    end
    alias_method :<<, :parse

    def content_length
      LLHttp.rb_llhttp_content_length(@pointer)
    end

    def method_name
      LLHttp.rb_llhttp_method_name(@pointer)
    end

    def status_code
      LLHttp.rb_llhttp_status_code(@pointer)
    end

    def keep_alive?
      LLHttp.llhttp_should_keep_alive(@pointer) == 1
    end

    def finish
      LLHttp.llhttp_finish(@pointer)
    end

    private def on_url(buffer, length)
      @delegate.on_url(buffer.get_bytes(0, length))
    end

    private def on_status(buffer, length)
      @delegate.on_status(buffer.get_bytes(0, length))
    end

    private def on_header_field(buffer, length)
      @delegate.on_header_field(buffer.get_bytes(0, length))
    end

    private def on_header_value(buffer, length)
      @delegate.on_header_value(buffer.get_bytes(0, length))
    end

    private def on_body(buffer, length)
      @delegate.on_body(buffer.get_bytes(0, length))
    end

    private def build_error(errno)
      # Error.new("Error Parsing data: #{LLHttp.llhttp_errno_name(errno).read_string} #{LLHttp.llhttp_get_error_reason(self).read_string}")

      Error.new("TODO")
    end
  end
end
