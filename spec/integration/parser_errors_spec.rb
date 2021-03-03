# frozen_string_literal: true

require_relative "support/context/parsing"

RSpec.describe "errors when parsing requests" do
  include_context "parsing"

  shared_examples "examples" do
    it "raises an error wrapping the llhttp error" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_INVALID_HEADER_TOKEN Invalid header token")
    end
  end

  context "request" do
    let(:type) {
      :request
    }

    let(:fixture) {
      :invalid_request_header
    }

    include_examples "examples"
  end

  context "response" do
    let(:type) {
      :response
    }

    let(:fixture) {
      :invalid_response_header
    }

    include_examples "examples"
  end
end
