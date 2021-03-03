# frozen_string_literal: true

require_relative "../../support/context/parsing"

RSpec.describe "request parsing callback errors" do
  include_context "parsing"

  let(:type) {
    :request
  }

  describe "on_message_begin" do
    let(:extension) {
      proc {
        def on_message_begin(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_MESSAGE_BEGIN `on_message_begin` callback error")
    end
  end

  describe "on_headers_complete" do
    let(:extension) {
      proc {
        def on_headers_complete(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_HEADERS_COMPLETE User callback error")
    end
  end

  describe "on_message_complete" do
    let(:extension) {
      proc {
        def on_message_complete(*args)
          fail
        end
      }
    }

    it "raises expectedly" do
      expect {
        parse
      }.to raise_error(LLHttp::Error, "Error Parsing data: HPE_CB_MESSAGE_COMPLETE `on_message_complete` callback error")
    end
  end

  describe "on_chunk_header" do
    let(:extension) {
      proc {
        def on_chunk_header(*args)
          fail
        end
      }
    }

    it "raises expectedly"
  end
end
