# frozen_string_literal: true

require "timeout"
require "async"
require "io/endpoint/host_endpoint"
require "io/endpoint/bound_endpoint"
require "llhttp"

require_relative "support/server"

RSpec.describe "parsing in context of a server" do
  before do
    endpoint = IO::Endpoint.tcp("0.0.0.0", 9000, reuse_address: true)
    @bound_endpoint = endpoint.bound

    @pid = Process.fork do
      Async do
        Server.new(@bound_endpoint).run

        parser = LLHttp::Parser.new(LLHttp::Delegate.new, type: :request)
        parser.parse("GET / HTTP/1.1\r\n")
      end
    end
  end

  after do
    Process.kill("HUP", @pid)
    Process.wait(@pid)
    @bound_endpoint&.close
  end

  it "parses" do
    Timeout.timeout(1) do
      expect(system("curl -v http://localhost:9000")).to be(true)
    end
  end
end
