# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: header field" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_header_field(*args)
          @calls << [:on_header_field, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_header_field, ["content-length"]]
      ])
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
