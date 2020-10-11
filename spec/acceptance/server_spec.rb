# frozen_string_literal: true

require "timeout"
require "async/io"
require "llhttp"

require_relative "support/server"

RSpec.describe "parsing in context of a server" do
  before do
    @pid = Process.fork {
      endpoint = Async::IO::Endpoint.tcp("0.0.0.0", 9000)

      Async do
        Server.new(endpoint).run

        parser = LLHttp::Parser.new(LLHttp::Delegate.new, type: :request)
        parser.parse("GET / HTTP/1.1\r\n")
      end
    }
  end

  after do
    Process.kill("HUP", @pid)
  end

  it "parses" do
    Timeout.timeout(1) do
      expect(system("curl -v http://localhost:9000")).to be(true)
    end
  end
end
