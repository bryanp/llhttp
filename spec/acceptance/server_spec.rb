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

  # The async-based test server requires Ruby >= 3.2: newer async drops 3.1, so
  # on older Rubies bundle resolves to a stack that can't serve the request.
  # llhttp core is still exercised by the rest of the suite on those versions.
  it "parses", skip: RUBY_VERSION < "3.2" && "async test server requires Ruby >= 3.2" do
    # Poll until the forked server is accepting and responding rather than
    # asserting on a single curl under a tight timeout, so a slow fork + Async
    # reactor cold start on a loaded CI runner costs a few retries, not a
    # spurious failure.
    result = false

    Timeout.timeout(10) do
      until (result = system("curl -sf http://localhost:9000", out: File::NULL, err: File::NULL))
        sleep(0.05)
      end
    end

    expect(result).to be(true)
  end
end
