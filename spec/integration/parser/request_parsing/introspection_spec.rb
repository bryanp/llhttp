# frozen_string_literal: true

require_relative "../../support/context/parsing"

RSpec.describe "request introspection" do
  include_context "parsing"

  let(:type) {
    :request
  }

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
end
