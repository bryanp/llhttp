# frozen_string_literal: true

require "llhttp"

RSpec.shared_context "parsing" do
  let(:instance) {
    LLHttp::Parser.new(delegate, type: type)
  }

  let(:type) {
    :both
  }

  let(:delegate) {
    local = self

    klass = Class.new(LLHttp::Delegate) {
      attr_reader :calls

      def initialize(context)
        @calls = []
        @context = context
      end

      class_eval(&local.extension)
    }

    klass.new(local)
  }

  let(:extension) {
    proc {}
  }

  let(:fixture) {
    case type
    when :response
      :response
    else
      :request
    end
  }

  let(:fixtures) {
    {
      chunked_request: [
        "GET / HTTP/1.1\r\n",
        "transfer-encoding: chunked\r\n",
        "\r\n",
        "7\r\n",
        "Mozilla\r\n",
        "9\r\n",
        "Developer\r\n",
        "7\r\n",
        "Network\r\n",
        "0\r\n",
        "\r\n"
      ],

      chunked_response: [
        "HTTP/1.1 200 OK\r\n",
        "transfer-encoding: chunked\r\n",
        "\r\n",
        "7\r\n",
        "Mozilla\r\n",
        "9\r\n",
        "Developer\r\n",
        "7\r\n",
        "Network\r\n",
        "0\r\n",
        "\r\n"
      ],

      invalid_request_header: [
        "GET / HTTP/1.1\r\n",
        "content-length\r\n"
      ],

      invalid_response_header: [
        "HTTP/1.1 200 OK\r\n",
        "content-length\r\n"
      ],

      request: [
        "GET / HTTP/1.1\r\n",
        "content-length: 18\r\n",
        "content-type: text/plain\r\n",
        "\r\n",
        "body1\n",
        "body2\n",
        "body3\n",
        "\r\n"
      ],

      response: [
        "HTTP/1.1 200 OK\r\n",
        "content-length: 18\r\n",
        "content-type: text/plain\r\n",
        "\r\n",
        "body1\n",
        "body2\n",
        "body3\n",
        "\r\n"
      ],

      response_sans_content_length: [
        "HTTP/1.1 200 OK\r\n\r\n"
      ]
    }
  }

  def parse(fixture = self.fixture)
    fixtures.fetch(fixture).each do |part|
      instance << part
    end
  end
end
