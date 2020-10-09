# llhttp

Ruby bindings for [llhttp](https://github.com/nodejs/llhttp).

## Install

```
gem install llhttp
```

## Usage

```ruby
require "llhttp/parser"

parser = LLHttp::Parser.new

parser.on_message_begin do
  ...
end

parser.on_url do |url|
  ...
end

parser.on_status do |status|
  ...
end

parser.on_header_field do |field|
  ...
end

parser.on_header_value do |value|
  ...
end

parser.on_headers_complete do
  ...
end

parser.on_body do |body|
  ...
end

parser.on_message_complete do
  ...
end

# Reset the parser for the next request:
#
parser.reset
```
