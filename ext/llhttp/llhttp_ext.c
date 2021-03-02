// This software is licensed under the MIT License.

// Copyright Bryan Powell, 2020.

// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

#include <stdlib.h>
#include <string.h>
#include "llhttp.h"

typedef struct rb_llhttp_callbacks_s rb_llhttp_callbacks_t;

typedef int (*rb_llhttp_data_cb)(const char *data, size_t length);
typedef int (*rb_llhttp_cb)();

struct rb_llhttp_callbacks_s {
  /* Possible return values 0, -1, `HPE_PAUSED` */
  rb_llhttp_cb      on_message_begin;

  rb_llhttp_data_cb on_url;
  rb_llhttp_data_cb on_status;
  rb_llhttp_data_cb on_header_field;
  rb_llhttp_data_cb on_header_value;

  /* Possible return values:
   * 0  - Proceed normally
   * 1  - Assume that request/response has no body, and proceed to parsing the
   *      next message
   * 2  - Assume absence of body (as above) and make `llhttp_execute()` return
   *      `HPE_PAUSED_UPGRADE`
   * -1 - Error
   * `HPE_PAUSED`
   */
  rb_llhttp_cb      on_headers_complete;

  rb_llhttp_data_cb on_body;

  /* Possible return values 0, -1, `HPE_PAUSED` */
  rb_llhttp_cb      on_message_complete;

  /* When on_chunk_header is called, the current chunk length is stored
   * in parser->content_length.
   * Possible return values 0, -1, `HPE_PAUSED`
   */
  rb_llhttp_cb      on_chunk_header;
  rb_llhttp_cb      on_chunk_complete;
};

int rb_llhttp_on_message_begin(llhttp_t *parser) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_message_begin();
  return 0;
}

int rb_llhttp_on_url(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_url(data, length);
  return 0;
}

int rb_llhttp_on_status(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_status(data, length);
  return 0;
}

int rb_llhttp_on_header_field(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_header_field(data, length);
  return 0;
}

int rb_llhttp_on_header_value(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_header_value(data, length);
  return 0;
}

int rb_llhttp_on_headers_complete(llhttp_t *parser) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_headers_complete();
  return 0;
}

int rb_llhttp_on_body(llhttp_t *parser, char *data, size_t length) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_body(data, length);
  return 0;
}

int rb_llhttp_on_message_complete(llhttp_t *parser) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_message_complete();
  return 0;
}

int rb_llhttp_on_chunk_header(llhttp_t *parser) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_chunk_header();
  return 0;
}

int rb_llhttp_on_chunk_complete(llhttp_t *parser) {
  rb_llhttp_callbacks_t* callbacks = parser->data;
  callbacks->on_chunk_complete();
  return 0;
}

// TODO: Don't forget the finalizer to dealloc things.

llhttp_t* rb_llhttp_init(int type, rb_llhttp_callbacks_t* callbacks) {
  llhttp_t *parser = (llhttp_t *)malloc(sizeof(llhttp_t));
  llhttp_settings_t *settings = (llhttp_settings_t *)malloc(sizeof(llhttp_settings_t));

  llhttp_settings_init(settings);

  settings->on_message_begin = (llhttp_cb)rb_llhttp_on_message_begin;

  settings->on_url = (llhttp_data_cb)rb_llhttp_on_url;
  settings->on_status = (llhttp_data_cb)rb_llhttp_on_status;
  settings->on_header_field = (llhttp_data_cb)rb_llhttp_on_header_field;
  settings->on_header_value = (llhttp_data_cb)rb_llhttp_on_header_value;

  settings->on_headers_complete = (llhttp_cb)rb_llhttp_on_headers_complete;

  settings->on_body = (llhttp_data_cb)rb_llhttp_on_body;

  settings->on_message_complete = (llhttp_cb)rb_llhttp_on_message_complete;

  settings->on_chunk_header = (llhttp_cb)rb_llhttp_on_chunk_header;
  settings->on_chunk_complete = (llhttp_cb)rb_llhttp_on_chunk_complete;

  llhttp_init(parser, type, settings);

  parser->data = callbacks;

  return parser;
}

uint64_t rb_llhttp_content_length(llhttp_t* parser) {
  return parser->content_length;
}

const char* rb_llhttp_method_name(llhttp_t* parser) {
  return llhttp_method_name(parser->method);
}

uint16_t rb_llhttp_status_code(llhttp_t* parser) {
  return parser->status_code;
}
