# frozen_string_literal: true

require "async/io"
require "async/io/stream"

class Delegate < LLHttp::Delegate
  def initialize
    @finished_headers = false
  end

  def finished_headers?
    @finished_headers == true
  end

  def on_headers_complete
    @finished_headers = true
  end

  def reset
    @finished_headers = false
  end
end

class Server
  CRLF = "\r\n"

  def initialize(endpoint)
    @endpoint = endpoint
    @delegate = Delegate.new
    @parser = LLHttp::Parser.new(@delegate, type: :request)
  end

  def run
    @endpoint.accept(&method(:accept))
  end

  private def accept(client, address, task:)
    stream = Async::IO::Stream.new(client, sync: false)

    while parse_next(stream)
      stream.write("HTTP/1.1 204 No Content\r\n")
      stream.write("content-length: 0\r\n\r\n")
      stream.flush

      @delegate.reset

      task.yield
    end
  ensure
    stream.close

    @parser.reset
  end

  private def parse_next(stream)
    while (line = stream.read_until(CRLF, chomp: false))
      @parser << line

      if @delegate.finished_headers?
        return true
      end
    end
  end
end
