# frozen_string_literal: true

module LLHttp
  # [public] Delegate for handling callbacks. Subclass this object and implement necessary methods.
  #
  #   class Delegate < LLHttp::Delegate
  #     def on_message_begin
  #       ...
  #     end
  #
  #     def on_url(url)
  #       ...
  #     end
  #
  #     def on_status(status)
  #       ...
  #     end
  #
  #     def on_header_field(field)
  #       ...
  #     end
  #
  #     def on_header_value(value)
  #       ...
  #     end
  #
  #     def on_headers_complete
  #       ...
  #     end
  #
  #     def on_body(body)
  #       ...
  #     end
  #
  #     def on_message_complete
  #       ...
  #     end
  #
  #     def on_chunk_header
  #       ...
  #     end
  #
  #     def on_chunk_complete
  #       ...
  #     end
  #
  #     def on_url_complete
  #       ...
  #     end
  #
  #     def on_status_complete
  #       ...
  #     end
  #
  #     def on_header_field_complete
  #       ...
  #     end
  #
  #     def on_header_value_complete
  #       ...
  #     end
  #   end
  #
  class Delegate
    # private def internal_on_message_begin
    #   on_message_begin

    #   0
    # rescue
    #   -1
    # end

    # private def internal_on_headers_complete
    #   on_headers_complete

    #   0
    # rescue
    #   -1
    # end

    # private def internal_on_message_complete
    #   on_message_complete

    #   0
    # rescue
    #   -1
    # end

    # private def internal_on_chunk_header
    #   on_chunk_header

    #   0
    # rescue
    #   -1
    # end
  end
end
