# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "introspection: method" do
  include_context "parsing"

  shared_examples "examples" do
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

  context "request" do
    let(:type) {
      :request
    }

    include_examples "examples"
  end
end
