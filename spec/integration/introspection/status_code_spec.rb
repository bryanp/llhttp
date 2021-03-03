# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "introspection: content length" do
  include_context "parsing"

  shared_examples "examples" do
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

  context "response" do
    let(:type) {
      :response
    }

    include_examples "examples"
  end
end
