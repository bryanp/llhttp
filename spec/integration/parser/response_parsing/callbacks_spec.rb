# frozen_string_literal: true

require_relative "../../support/context/parsing"

RSpec.describe "parsing responses" do
  include_context "parsing"

  let(:type) {
    :response
  }

  describe "on_message_begin" do
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

  describe "on_status" do
    let(:extension) {
      proc {
        def on_status(*args)
          @calls << [:on_status, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_status, ["OK"]]
      ])
    end
  end

  describe "on_header_field" do
    let(:extension) {
      proc {
        def on_header_field(*args)
          @calls << [:on_header_field, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_header_field, ["content-length"]]
      ])
    end
  end

  describe "on_header_value" do
    let(:extension) {
      proc {
        def on_header_value(*args)
          @calls << [:on_header_value, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_header_value, ["18"]]
      ])
    end
  end

  describe "on_headers_complete" do
    let(:extension) {
      proc {
        def on_headers_complete(*args)
          @calls << [:on_headers_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_headers_complete, []]
      ])
    end
  end

  describe "on_body" do
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

  describe "on_message_complete" do
    let(:extension) {
      proc {
        def on_message_complete(*args)
          @calls << [:on_message_complete, args]
        end
      }
    }

    it "is called" do
      parse

      expect(delegate.calls).to eq([
        [:on_message_complete, []]
      ])
    end
  end
end
