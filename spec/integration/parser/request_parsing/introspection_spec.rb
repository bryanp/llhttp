# frozen_string_literal: true

require "llhttp"

RSpec.describe "request introspection" do
  let(:instance) {
    LLHttp::Parser.new(delegate, type: :request)
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
    instance << "GET / HTTP/1.1\r\n"
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

  describe "method" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@method, @context.instance.method)
        end
      }
    }

    it "returns the content" do
      parse

      expect(@method).to eq("GET")
    end
  end

  describe "keep_alive" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@keep_alive, @context.instance.keep_alive?)
        end
      }
    }

    it "returns the keep alive state" do
      parse

      expect(@keep_alive).to eq(true)
    end
  end
end
