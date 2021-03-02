# frozen_string_literal: true

module LLHttp
  # [public] Delegate for handling callbacks. Subclass this object and implement necessary methods.
  #
  #   class Delegate < LLHttp::Delegate
  #     def on_message_begin
  #       ...
  #     end
  #
  #     ...
  #   end
  #
  class Delegate
    # [public]
    #
    def on_message_begin
    end

    # [public]
    #
    def on_url(url)
    end

    # [public]
    #
    def on_status(status)
    end

    # [public]
    #
    def on_header_field(field)
    end

    # [public]
    #
    def on_header_value(value)
    end

    # [public]
    #
    def on_headers_complete
    end

    # [public]
    #
    def on_body(body)
    end

    # [public]
    #
    def on_message_complete
    end

    # [public]
    #
    def on_chunk_header
    end

    # [public]
    #
    def on_chunk_complete
    end

    private def internal_on_message_begin
      on_message_begin

      0
    rescue
      -1
    end

    private def internal_on_headers_complete
      on_headers_complete

      0
    rescue
      -1
    end

    private def internal_on_message_complete
      on_message_complete

      0
    rescue
      -1
    end

    private def internal_on_chunk_header
      on_chunk_header

      0
    rescue
      -1
    end
  end
end
