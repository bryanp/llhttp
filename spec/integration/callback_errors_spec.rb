# frozen_string_literal: true

require_relative "support/context/parsing"

RSpec.describe "errors when parsing requests" do
  include_context "parsing"

  shared_examples "examples" do
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
