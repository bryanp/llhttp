# frozen_string_literal: true

require "ffi"
require "ffi-compiler/loader"

module LLHttp
  require_relative "llhttp/delegate"
  require_relative "llhttp/error"
  require_relative "llhttp/parser"
  require_relative "llhttp/version"

  class Instance < FFI::Struct
    layout :_index, :int32,
      :_span_pos0, :pointer,
      :_span_cb0, :pointer,
      :error, :int32,
      :reason, :pointer,
      :error_pos, :pointer,
      :data, :pointer,
      :_current, :pointer,
      :content_length, :uint64,
      :type, :uint8,
      :method, :uint8,
      :http_major, :uint8,
      :http_minor, :uint8,
      :header_state, :uint8,
      :flags, :uint8,
      :upgrade, :uint8,
      :status_code, :uint16,
      :finish, :uint8,
      :settings, :pointer

    def initialize(pointer, type = nil, delegate = nil)
      if pointer
        # FFI is initializing the object with a pointer.
        #
        super(pointer)
      else
        super()

        @delegate = delegate
        @settings = build_settings
        LLHttp.llhttp_init(self, type, @settings)
      end
    end

    def parse(data)
      errno = LLHttp.llhttp_execute(self, data, data.length)
      raise build_error(errno) if errno > 0
    end
    alias_method :<<, :parse

    def content_length
      self[:content_length]
    end

    def method_name
      LLHttp.llhttp_method_name(self[:method]).read_string
    end

    def status_code
      self[:status_code]
    end

    def keep_alive?
      LLHttp.llhttp_should_keep_alive(self) == 1
    end

    def on_message_begin(instance)
      @delegate.on_message_begin

      nil
    end

    def on_url(instance, pointer, length)
      @delegate.on_url(pointer.read_string(length))

      nil
    end

    def on_status(instance, pointer, length)
      @delegate.on_status(pointer.read_string(length))

      nil
    end

    def on_header_field(instance, pointer, length)
      @delegate.on_header_field(pointer.read_string(length))

      nil
    end

    def on_header_value(instance, pointer, length)
      @delegate.on_header_value(pointer.read_string(length))

      nil
    end

    def on_headers_complete(instance)
      @delegate.on_headers_complete

      nil
    end

    def on_body(instance, pointer, length)
      @delegate.on_body(pointer.read_string(length))

      nil
    end

    def on_message_complete(instance)
      @delegate.on_message_complete

      nil
    end

    def on_chunk_header(instance)
      @delegate.on_chunk_header

      nil
    end

    def on_chunk_complete(instance)
      @delegate.on_chunk_complete

      nil
    end

    private def build_settings
      settings = Settings.new
      settings[:on_message_begin] = method(:on_message_begin).to_proc
      settings[:on_url] = method(:on_url).to_proc
      settings[:on_status] = method(:on_status).to_proc
      settings[:on_header_field] = method(:on_header_field).to_proc
      settings[:on_header_value] = method(:on_header_value).to_proc
      settings[:on_headers_complete] = method(:on_headers_complete).to_proc
      settings[:on_body] = method(:on_body).to_proc
      settings[:on_message_complete] = method(:on_message_complete).to_proc
      settings[:on_chunk_header] = method(:on_chunk_header).to_proc
      settings[:on_chunk_complete] = method(:on_chunk_complete).to_proc
      settings
    end

    private def build_error(errno)
      Error.new("Error Parsing data: #{LLHttp.llhttp_errno_name(errno).read_string} #{LLHttp.llhttp_get_error_reason(self).read_string}")
    end
  end

  extend FFI::Library
  ffi_lib(FFI::Compiler::Loader.find("llhttp-ext"))

  callback :llhttp_data_cb, [:pointer, :pointer, :size_t], :int
  callback :llhttp_cb, [:pointer], :int

  class Settings < FFI::Struct
    layout :on_message_begin, :llhttp_cb,
      :on_url, :llhttp_data_cb,
      :on_status, :llhttp_data_cb,
      :on_header_field, :llhttp_data_cb,
      :on_header_value, :llhttp_data_cb,
      :on_headers_complete, :llhttp_cb,
      :on_body, :llhttp_data_cb,
      :on_message_complete, :llhttp_cb,
      :on_chunk_header, :llhttp_cb,
      :on_chunk_complete, :llhttp_cb
  end

  attach_function :llhttp_init, [Instance.by_ref, :int, Settings.by_ref], :void
  attach_function :llhttp_execute, [Instance.by_ref, :pointer, :size_t], :int
  attach_function :llhttp_method_name, [:int], :pointer
  attach_function :llhttp_errno_name, [:int], :pointer
  attach_function :llhttp_get_error_reason, [Instance.by_ref], :pointer
  attach_function :llhttp_should_keep_alive, [Instance.by_ref], :int
  attach_function :llhttp_finish, [Instance.by_ref], :int
end
