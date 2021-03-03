# frozen_string_literal: true

require_relative "../support/context/parsing"

RSpec.describe "callbacks: body" do
  include_context "parsing"

  shared_examples "examples" do
    let(:extension) {
      proc {
        def on_body(*args)
          @calls << [:on_body, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_body, ["body1\n"]],
        [:on_body, ["body2\n"]],
        [:on_body, ["body3\n"]]
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
