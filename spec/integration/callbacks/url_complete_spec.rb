# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: url complete" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_url_complete(*args)
          @calls << [:on_url_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_url_complete, []]
      ])
    end
  end

  context "request" do
    let(:type) {
      :request
    }

    include_examples "examples"
  end
end
