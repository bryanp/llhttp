# frozen_string_literal: true

require "llhttp"

RSpec.describe "parsing multiple requests" do
  let(:instance) {
    LLHttp::Parser.new(delegate, type: :request)
  }

  let(:delegate) {
    klass = Class.new(LLHttp::Delegate) {
      attr_reader :calls

      def initialize
        @calls = []
      end

      def on_message_begin
        @calls << :on_message_begin
      end

      def on_url(_)
        @calls << :on_url
      end

      def on_header_field(_)
        @calls << :on_header_field
      end

      def on_header_value(_)
        @calls << :on_header_value
      end

      def on_headers_complete
        @calls << :on_headers_complete
      end

      def on_body(_)
        @calls << :on_body
      end

      def on_message_complete
        @calls << :on_message_complete
      end
    }

    klass.new
  }

  def parse
    instance << "GET / HTTP/1.1\r\n"
    instance << "content-length: 18\r\n"
    instance << "\r\n"
    instance << "body1\n"
    instance << "body2\n"
    instance << "body3\n"
    instance << "\r\n"
  end

  it "parses correctly" do
    10_000.times do
      parse

      instance.finish
    end

    expect(delegate.calls.count(:on_message_begin)).to eq(10_000)
    expect(delegate.calls.count(:on_url)).to eq(10_000)
    expect(delegate.calls.count(:on_header_field)).to eq(10_000)
    expect(delegate.calls.count(:on_header_value)).to eq(10_000)
    expect(delegate.calls.count(:on_headers_complete)).to eq(10_000)
    expect(delegate.calls.count(:on_body)).to eq(30_000)
    expect(delegate.calls.count(:on_message_complete)).to eq(10_000)
  end
end
