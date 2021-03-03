# frozen_string_literal: true

require_relative "support/context/parsing"

RSpec.describe "reusing a parser instance" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_message_begin
          @calls << :on_message_begin
        end

        def on_header_field(_)
          @calls << :on_header_field
        end

        def on_header_value(_)
          @calls << :on_header_value
        end

        def on_headers_complete
          @calls << :on_headers_complete
        end

        def on_body(_)
          @calls << :on_body
        end

        def on_message_complete
          @calls << :on_message_complete
        end
      }
    }

    it "parses correctly" do
      10_000.times do
        parse

        instance.finish
      end

      expect(delegate.calls.count(:on_message_begin)).to eq(10_000)
      expect(delegate.calls.count(:on_header_field)).to eq(20_000)
      expect(delegate.calls.count(:on_header_value)).to eq(20_000)
      expect(delegate.calls.count(:on_headers_complete)).to eq(10_000)
      expect(delegate.calls.count(:on_body)).to eq(30_000)
      expect(delegate.calls.count(:on_message_complete)).to eq(10_000)
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
