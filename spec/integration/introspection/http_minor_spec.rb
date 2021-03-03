# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "introspection: http minor" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@http_minor, @context.instance.http_minor)
        end
      }
    }

    it "returns the http minor version" do
      parse

      expect(@http_minor).to eq(1)
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
