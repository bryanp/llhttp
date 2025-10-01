# frozen_string_literal: true

require "mkmf"

dir_config("llhttp_ext")

# Check for Ractor support
have_func("rb_ext_ractor_safe", "ruby.h")

create_makefile("llhttp_ext")
