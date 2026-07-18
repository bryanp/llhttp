# frozen_string_literal: true

# Regression test for a GC-compaction bug: the C parser struct caches the
# delegate `VALUE` but registered no GC mark callback, so compaction could move
# the delegate and leave the cached copy dangling -- crashing (or raising a
# type-confusion error) the next time a callback fired.
#
# The failure can be a hard interpreter crash, so it runs in a child process.
RSpec.describe "parsing after GC compaction" do
  it "keeps the cached delegate valid across compaction" do
    skip "compaction unavailable" unless GC.respond_to?(:verify_compaction_references)

    script = <<~'RUBY'
      require "llhttp"

      class Delegate < LLHttp::Delegate
        def on_header_field(_) = nil
      end

      # Build in a separate frame so the delegate is reachable only through the
      # parser's @delegate ivar -- a movable heap slot compaction will relocate.
      def build = LLHttp::Parser.new(Delegate.new, type: :response)

      10.times do
        parser = build
        GC.verify_compaction_references(expand_heap: true, toward: :empty)
        parser << "HTTP/1.1 200 OK\r\nX-Test: yes\r\n\r\n"
      end

      print "COMPACTION_SURVIVED"
    RUBY

    # stderr is merged in so a crash backtrace shows in the failure message;
    # match a sentinel rather than the whole stream, which may carry unrelated
    # RubyGems warnings from the child's environment.
    output = IO.popen([RbConfig.ruby, *$LOAD_PATH.flat_map { |p| ["-I", p] }, "-e", script], err: %i[child out], &:read)

    expect($?).to be_success, "child process crashed:\n#{output}"
    expect(output).to include("COMPACTION_SURVIVED")
  end
end
