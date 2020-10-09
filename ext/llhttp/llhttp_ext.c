#include <ruby/ruby.h>
#include "vendor/api.c"

static VALUE test(VALUE klass) {
  llhttp_t parser;
  llhttp_settings_t settings;

  llhttp_settings_init(&settings);

  return rb_str_new2("works");
}

void Init_llhttp_ext(void) {
  VALUE cLLHttp, cLLHttpParser;

  cLLHttp = rb_const_get(rb_cObject, rb_intern("LLHttp"));
  cLLHttpParser = rb_const_get(cLLHttp, rb_intern("Parser"));

  rb_define_method(cLLHttpParser, "test", test, 0);
}
