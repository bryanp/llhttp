# frozen_string_literal: true

RSpec.describe "errors when parsing requests" do
  let(:instance) {
    LLHttp::Parser.new(LLHttp::Delegate.new, type: :request)
  }

  it "raises an error wrapping the llhttp error" do
    expect {
      instance << "GET / HTTP/1.1\r\n"
      instance << "content-length\r\n"
    }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_INVALID_HEADER_TOKEN Invalid header token")
  end
end
