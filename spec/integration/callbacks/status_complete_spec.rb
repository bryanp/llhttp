# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: status complete" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_status_complete(*args)
          @calls << [:on_status_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_status_complete, []]
      ])
    end
  end

  context "response" do
    let(:type) {
      :response
    }

    include_examples "examples"
  end
end
