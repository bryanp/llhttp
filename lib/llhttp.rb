# frozen_string_literal: true

require "ffi"
require "ffi-compiler/loader"

module LLHttp
  require_relative "llhttp/delegate"
  require_relative "llhttp/error"
  require_relative "llhttp/parser"
  require_relative "llhttp/version"

  extend FFI::Library
  ffi_lib(FFI::Compiler::Loader.find("llhttp-ext"))

  # TODO: These should return int, which should be returned to llhttp. Document possible return values.
  #
  callback :llhttp_data_cb, [:pointer, :size_t], :void
  callback :llhttp_cb, [], :void

  class Callbacks < FFI::Struct
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

  attach_function :rb_llhttp_init, [:int, Callbacks.by_ref], :pointer
  attach_function :rb_llhttp_content_length, [:pointer], :uint64
  attach_function :rb_llhttp_method_name, [:pointer], :string
  attach_function :rb_llhttp_status_code, [:pointer], :uint16

  attach_function :llhttp_execute, [:pointer, :pointer, :size_t], :int
  # attach_function :llhttp_errno_name, [:int], :pointer
  # attach_function :llhttp_get_error_reason, [Instance.by_ref], :pointer
  attach_function :llhttp_should_keep_alive, [:pointer], :int
  attach_function :llhttp_finish, [:pointer], :int
end
