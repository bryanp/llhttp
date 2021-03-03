# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "introspection: content length" do
  include_context "parsing"

  shared_examples "examples" do
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

  context "request" do
    let(:type) {
      :request
    }

    include_examples "examples"
  end

  context "response" do
    let(:type) {
      :response
    }

    include_examples "examples"
  end
end
