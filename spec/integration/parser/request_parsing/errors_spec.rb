# frozen_string_literal: true

require_relative "../../support/context/parsing"

RSpec.describe "errors when parsing requests" do
  include_context "parsing"

  let(:type) {
    :request
  }

  it "raises an error wrapping the llhttp error" do
    expect {
      parse(:invalid_header)
    }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_INVALID_HEADER_TOKEN Invalid header token")
  end
end
