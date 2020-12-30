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
  end
end
