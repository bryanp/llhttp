/*
  This software is licensed under the MPL-2.0 License.

  Copyright Bryan Powell, 2020.
*/

#include <ruby/ruby.h>

#include "llhttp.h"

static VALUE mLLHttp, cParser, eError;

typedef struct {
  VALUE delegate;
  ID on_message_begin;
  ID on_url;
  ID on_status;
  ID on_header_field;
  ID on_header_value;
  ID on_headers_complete;
  ID on_body;
  ID on_message_complete;
  ID on_chunk_header;
  ID on_chunk_complete;
  ID on_url_complete;
  ID on_status_complete;
  ID on_header_field_complete;
  ID on_header_value_complete;
} rb_llhttp_parser_data;

static void rb_llhttp_free(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  // If `parserData` is not `0`, it (and settings) were initialized.
  //
  if (parserData != 0) {
    free(parserData);
    free(parser->settings);
  }

  free(parser);
}

VALUE rb_llhttp_allocate(VALUE klass) {
  llhttp_t *parser = (llhttp_t *)malloc(sizeof(llhttp_t));

  // Set data to false so we know when the parser has been initialized.
  //
  parser->data = 0;

  return Data_Wrap_Struct(klass, 0, rb_llhttp_free, parser);
}

VALUE rb_llhttp_callback_call(VALUE delegate, ID method) {
  return rb_funcall(delegate, method, 0);
}

void rb_llhttp_data_callback_call(VALUE delegate, ID method, char *data, size_t length) {
  rb_funcall(delegate, method, 1, rb_str_new(data, length));
}

int rb_llhttp_on_message_begin(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  return NUM2INT(rb_llhttp_callback_call(parserData->delegate, parserData->on_message_begin));
}

int rb_llhttp_on_headers_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  return NUM2INT(rb_llhttp_callback_call(parserData->delegate, parserData->on_headers_complete));
}

int rb_llhttp_on_message_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  return NUM2INT(rb_llhttp_callback_call(parserData->delegate, parserData->on_message_complete));
}

int rb_llhttp_on_chunk_header(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  return NUM2INT(rb_llhttp_callback_call(parserData->delegate, parserData->on_chunk_header));
}

int rb_llhttp_on_url(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_data_callback_call(parserData->delegate, parserData->on_url, data, length);

  return 0;
}

int rb_llhttp_on_status(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_data_callback_call(parserData->delegate, parserData->on_status, data, length);

  return 0;
}

int rb_llhttp_on_header_field(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_data_callback_call(parserData->delegate, parserData->on_header_field, data, length);

  return 0;
}

int rb_llhttp_on_header_value(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_data_callback_call(parserData->delegate, parserData->on_header_value, data, length);

  return 0;
}

int rb_llhttp_on_body(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_data_callback_call(parserData->delegate, parserData->on_body, data, length);

  return 0;
}

int rb_llhttp_on_chunk_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_callback_call(parserData->delegate, parserData->on_chunk_complete);

  return 0;
}

int rb_llhttp_on_url_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_callback_call(parserData->delegate, parserData->on_url_complete);

  return 0;
}

int rb_llhttp_on_status_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_callback_call(parserData->delegate, parserData->on_status_complete);

  return 0;
}

int rb_llhttp_on_header_field_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_callback_call(parserData->delegate, parserData->on_header_field_complete);

  return 0;
}

int rb_llhttp_on_header_value_complete(llhttp_t *parser) {
  rb_llhttp_parser_data *parserData = (rb_llhttp_parser_data*) parser->data;

  rb_llhttp_callback_call(parserData->delegate, parserData->on_header_value_complete);

  return 0;
}

VALUE rb_llhttp_parse(VALUE self, VALUE data) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  enum llhttp_errno err = llhttp_execute(parser, RSTRING_PTR(data), RSTRING_LEN(data));

  if (err != HPE_OK) {
    rb_raise(eError, "Error Parsing data: %s %s", llhttp_errno_name(err), parser->reason);
  }

  return Qtrue;
}

VALUE rb_llhttp_finish(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  enum llhttp_errno err = llhttp_finish(parser);

  if (err != HPE_OK) {
    rb_raise(eError, "Error Parsing data: %s %s", llhttp_errno_name(err), parser->reason);
  }

  return Qtrue;
}

VALUE rb_llhttp_reset(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  llhttp_reset(parser);

  return Qtrue;
}

VALUE rb_llhttp_content_length(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  return ULL2NUM(parser->content_length);
}

VALUE rb_llhttp_method_name(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  return rb_str_new_cstr(llhttp_method_name(parser->method));
}

VALUE rb_llhttp_status_code(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  return UINT2NUM(parser->status_code);
}

VALUE rb_llhttp_http_major(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  return UINT2NUM(parser->http_major);
}

VALUE rb_llhttp_http_minor(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  return UINT2NUM(parser->http_minor);
}

VALUE rb_llhttp_keep_alive(VALUE self) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  int ret = llhttp_should_keep_alive(parser);

  return ret == 1 ? Qtrue : Qfalse;
}

static VALUE rb_llhttp_init(VALUE self, VALUE type) {
  llhttp_t *parser;

  Data_Get_Struct(self, llhttp_t, parser);

  llhttp_settings_t *settings = (llhttp_settings_t *)malloc(sizeof(llhttp_settings_t));
  llhttp_settings_init(settings);

  rb_llhttp_parser_data *parserData = malloc(sizeof(rb_llhttp_parser_data));
  parserData->delegate = rb_iv_get(self, "@delegate");

  parserData->on_message_begin = rb_intern("internal_on_message_begin");
  parserData->on_headers_complete = rb_intern("internal_on_headers_complete");
  parserData->on_message_complete = rb_intern("internal_on_message_complete");
  parserData->on_chunk_header = rb_intern("internal_on_chunk_header");
  parserData->on_url = rb_intern("on_url");
  parserData->on_status = rb_intern("on_status");
  parserData->on_header_field = rb_intern("on_header_field");
  parserData->on_header_value = rb_intern("on_header_value");
  parserData->on_body = rb_intern("on_body");
  parserData->on_chunk_complete = rb_intern("on_chunk_complete");
  parserData->on_url_complete = rb_intern("on_url_complete");
  parserData->on_status_complete = rb_intern("on_status_complete");
  parserData->on_header_field_complete = rb_intern("on_header_field_complete");
  parserData->on_header_value_complete = rb_intern("on_header_value_complete");

  if (rb_respond_to(parserData->delegate, rb_intern("on_message_begin"))) {
    settings->on_message_begin = (llhttp_cb)rb_llhttp_on_message_begin;
  }

  if (rb_respond_to(parserData->delegate, rb_intern("on_headers_complete"))) {
    settings->on_headers_complete = (llhttp_cb)rb_llhttp_on_headers_complete;
  }

  if (rb_respond_to(parserData->delegate, rb_intern("on_message_complete"))) {
    settings->on_message_complete = (llhttp_cb)rb_llhttp_on_message_complete;
  }

  if (rb_respond_to(parserData->delegate, rb_intern("on_chunk_header"))) {
    settings->on_chunk_header = (llhttp_cb)rb_llhttp_on_chunk_header;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_url)) {
    settings->on_url = (llhttp_data_cb)rb_llhttp_on_url;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_status)) {
    settings->on_status = (llhttp_data_cb)rb_llhttp_on_status;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_header_field)) {
    settings->on_header_field = (llhttp_data_cb)rb_llhttp_on_header_field;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_header_value)) {
    settings->on_header_value = (llhttp_data_cb)rb_llhttp_on_header_value;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_body)) {
    settings->on_body = (llhttp_data_cb)rb_llhttp_on_body;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_chunk_complete)) {
    settings->on_chunk_complete = (llhttp_cb)rb_llhttp_on_chunk_complete;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_url_complete)) {
    settings->on_url_complete = (llhttp_cb)rb_llhttp_on_url_complete;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_status_complete)) {
    settings->on_status_complete = (llhttp_cb)rb_llhttp_on_status_complete;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_header_field_complete)) {
    settings->on_header_field_complete = (llhttp_cb)rb_llhttp_on_header_field_complete;
  }

  if (rb_respond_to(parserData->delegate, parserData->on_header_value_complete)) {
    settings->on_header_value_complete = (llhttp_cb)rb_llhttp_on_header_value_complete;
  }

  llhttp_init(parser, FIX2INT(type), settings);

  parser->data = (void*)parserData;

  return Qtrue;
}

void Init_llhttp_ext(void) {
#ifdef HAVE_RB_EXT_RACTOR_SAFE
  rb_ext_ractor_safe(true);
#endif

  mLLHttp = rb_const_get(rb_cObject, rb_intern("LLHttp"));
  cParser = rb_const_get(mLLHttp, rb_intern("Parser"));
  eError = rb_const_get(mLLHttp, rb_intern("Error"));

  rb_define_alloc_func(cParser, rb_llhttp_allocate);

  rb_define_method(cParser, "<<", rb_llhttp_parse, 1);
  rb_define_method(cParser, "parse", rb_llhttp_parse, 1);
  rb_define_method(cParser, "finish", rb_llhttp_finish, 0);
  rb_define_method(cParser, "reset", rb_llhttp_reset, 0);

  rb_define_method(cParser, "content_length", rb_llhttp_content_length, 0);
  rb_define_method(cParser, "method_name", rb_llhttp_method_name, 0);
  rb_define_method(cParser, "status_code", rb_llhttp_status_code, 0);
  rb_define_method(cParser, "http_major", rb_llhttp_http_major, 0);
  rb_define_method(cParser, "http_minor", rb_llhttp_http_minor, 0);

  rb_define_method(cParser, "keep_alive?", rb_llhttp_keep_alive, 0);

  rb_define_private_method(cParser, "llhttp_init", rb_llhttp_init, 1);
}
