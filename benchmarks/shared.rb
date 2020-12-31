# frozen_string_literal: true

require "benchmark/ips"
require "llhttp"

def parse(instance)
  instance << "GET / HTTP/1.1\r\n"
  instance << "content-length: 18\r\n"
  instance << "\r\n"
  instance << "body1\n"
  instance << "body2\n"
  instance << "body3\n"
  instance << "\r\n"
end

def benchmark
  delegate = LLHttp::Delegate.new
  instance = LLHttp::Parser.new(delegate, type: :request)

  Benchmark.ips do |x|
    x.report do
      parse(instance)
      instance.finish
    end
  end
end
