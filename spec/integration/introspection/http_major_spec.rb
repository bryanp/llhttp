# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "introspection: http major" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_headers_complete
          @context.instance_variable_set(:@http_major, @context.instance.http_major)
        end
      }
    }

    it "returns the http major version" do
      parse

      expect(@http_major).to eq(1)
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
