# frozen_string_literal: true

require "llhttp"

RSpec.describe "request parsing callback errors" do
  let(:instance) {
    LLHttp::Parser.new(delegate, type: :request)
  }

  let(:delegate) {
    local = self

    klass = Class.new(LLHttp::Delegate) {
      attr_reader :calls

      def initialize
        @calls = []
      end

      class_eval(&local.extension)
    }

    klass.new
  }

  let(:extension) {
    proc {}
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

  describe "on_message_begin" do
    let(:extension) {
      proc {
        def on_message_begin(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_MESSAGE_BEGIN `on_message_begin` callback error")
    end
  end

  describe "on_headers_complete" do
    let(:extension) {
      proc {
        def on_headers_complete(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_HEADERS_COMPLETE User callback error")
    end
  end

  describe "on_message_complete" do
    let(:extension) {
      proc {
        def on_message_complete(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_MESSAGE_COMPLETE `on_message_complete` callback error")
    end
  end

  describe "on_chunk_header" do
    let(:extension) {
      proc {
        def on_chunk_header(*args)
          fail
        end
      }
    }

    it "raises expectedly"
  end
end
