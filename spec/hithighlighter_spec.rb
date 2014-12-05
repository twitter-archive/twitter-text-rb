# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

class TestHitHighlighter
  include Twitter::HitHighlighter
end

describe Twitter::HitHighlighter do
  describe "highlight" do
    before do
      @highlighter = TestHitHighlighter.new
    end

    context "with options" do
      before do
        @original = "Testing this hit highliter"
        @hits = [[13,16]]
      end

      it "should default to <em> tags" do
        expect(@highlighter.hit_highlight(@original, @hits)).to eq("Testing this <em>hit</em> highliter")
      end

      it "should allow tag override" do
        expect(@highlighter.hit_highlight(@original, @hits, :tag => 'b')).to eq("Testing this <b>hit</b> highliter")
      end
    end

    context "without links" do
      before do
        @original = "Hey! this is a test tweet"
      end

      it "should return original when no hits are provided" do
        expect(@highlighter.hit_highlight(@original)).to eq(@original)
      end

      it "should highlight one hit" do
        expect(@highlighter.hit_highlight(@original, hits = [[5, 9]])).to eq("Hey! <em>this</em> is a test tweet")
      end

      it "should highlight two hits" do
        expect(@highlighter.hit_highlight(@original, hits = [[5, 9], [15, 19]])).to eq("Hey! <em>this</em> is a <em>test</em> tweet")
      end

      it "should correctly highlight first-word hits" do
        expect(@highlighter.hit_highlight(@original, hits = [[0, 3]])).to eq("<em>Hey</em>! this is a test tweet")
      end

      it "should correctly highlight last-word hits" do
        expect(@highlighter.hit_highlight(@original, hits = [[20, 25]])).to eq("Hey! this is a test <em>tweet</em>")
      end
    end

    context "with links" do
      it "should highlight with a single link" do
        expect(@highlighter.hit_highlight("@<a>bcherry</a> this was a test tweet", [[9, 13]])).to eq("@<a>bcherry</a> <em>this</em> was a test tweet")
      end

      it "should highlight with link at the end" do
        expect(@highlighter.hit_highlight("test test <a>test</a>", [[5, 9]])).to eq("test <em>test</em> <a>test</a>")
      end

      it "should highlight with a link at the beginning" do
        expect(@highlighter.hit_highlight("<a>test</a> test test", [[5, 9]])).to eq("<a>test</a> <em>test</em> test")
      end

      it "should highlight an entire link" do
        expect(@highlighter.hit_highlight("test <a>test</a> test", [[5, 9]])).to eq("test <a><em>test</em></a> test")
      end

      it "should highlight within a link" do
        expect(@highlighter.hit_highlight("test <a>test</a> test", [[6, 8]])).to eq("test <a>t<em>es</em>t</a> test")
      end

      it "should highlight around a link" do
        expect(@highlighter.hit_highlight("test <a>test</a> test", [[3, 11]])).to eq("tes<em>t <a>test</a> t</em>est")
      end

      it "should fail gracefully with bad hits" do
        expect(@highlighter.hit_highlight("test test", [[5, 20]])).to eq("test <em>test</em>")
      end

      it "should not mess up with touching tags" do
        expect(@highlighter.hit_highlight("<a>foo</a><a>foo</a>", [[3,6]])).to eq("<a>foo</a><a><em>foo</em></a>")
      end

    end

  end

end
