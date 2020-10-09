# frozen_string_literal: true

require "llhttp"

RSpec.describe LLHttp::Parser do
  describe "#test" do
    it "works" do
      expect(subject.test).to eq("works")
    end
  end
end
