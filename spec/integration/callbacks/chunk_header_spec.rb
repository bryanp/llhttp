# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: chunk header" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_chunk_header(*args)
          @calls << [:on_chunk_header, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_chunk_header, []],
        [:on_chunk_header, []],
        [:on_chunk_header, []],
        [:on_chunk_header, []]
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
