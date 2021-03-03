# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: chunk complete" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_chunk_complete(*args)
          @calls << [:on_chunk_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_chunk_complete, []],
        [:on_chunk_complete, []],
        [:on_chunk_complete, []],
        [:on_chunk_complete, []]
      ])
    end
  end

  context "request" do
    let(:type) {
      :request
    }

    let(:fixture) {
      :chunked_request
    }

    include_examples "examples"
  end

  context "response" do
    let(:type) {
      :response
    }

    let(:fixture) {
      :chunked_response
    }

    include_examples "examples"
  end
end
