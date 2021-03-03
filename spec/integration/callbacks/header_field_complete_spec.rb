# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: header field complete" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_header_field_complete(*args)
          @calls << [:on_header_field_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_header_field_complete, []],
        [:on_header_field_complete, []]
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
