# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: message begin" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_message_begin(*args)
          @calls << [:on_message_begin, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_message_begin, []]
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
