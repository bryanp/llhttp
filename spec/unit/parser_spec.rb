# frozen_string_literal: true

require "llhttp"

RSpec.describe LLHttp::Parser do
  let(:delegate) {
    LLHttp::Delegate.new
  }

  it "initializes with a default type" do
    instance = described_class.new(delegate)
    expect(instance).to be_instance_of(described_class)
    expect(instance.type).to eq(:both)
  end

  it "initializes with type: :request" do
    instance = described_class.new(delegate, type: :request)
    expect(instance).to be_instance_of(described_class)
    expect(instance.type).to eq(:request)
  end

  it "initializes with type: response" do
    instance = described_class.new(delegate, type: :response)
    expect(instance).to be_instance_of(described_class)
    expect(instance.type).to eq(:response)
  end

  it "initializes with type: both" do
    instance = described_class.new(delegate, type: :both)
    expect(instance).to be_instance_of(described_class)
    expect(instance.type).to eq(:both)
  end

  it "raises an error when type is invalid" do
    expect {
      described_class.new(delegate, type: :invalid)
    }.to raise_error(KeyError, "key not found: :invalid")
  end
end
