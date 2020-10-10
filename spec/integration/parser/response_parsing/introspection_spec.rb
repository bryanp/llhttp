# frozen_string_literal: true

require "llhttp"

RSpec.describe "response introspection" do
  let(:instance) {
    LLHttp::Parser.new(delegate, type: :response)
  }

  let(:delegate) {
    local = self

    klass = Class.new(LLHttp::Delegate) {
      def initialize(context)
        @context = context
      end

      class_eval(&local.extension)
    }

    klass.new(self)
  }

  let(:extension) {
    proc {}
  }

  def parse
    instance << "HTTP/1.1 200 OK\r\n"
    instance << "content-length: 18\r\n"
    instance << "\r\n"
    instance << "body1\n"
    instance << "body2\n"
    instance << "body3\n"
    instance << "\r\n"
  end

  describe "content_length" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@content_length, @context.instance.content_length)
        end
      }
    }

    it "returns the content length" do
      parse

      expect(@content_length).to eq(18)
    end
  end

  describe "status_code" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@status_code, @context.instance.status_code)
        end
      }
    }

    it "returns the content" do
      parse

      expect(@status_code).to eq(200)
    end
  end
end
