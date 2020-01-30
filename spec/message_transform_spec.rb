require 'message_transform'

RSpec.describe MessageTransform, "#process" do
  context "using a passed regex pattern and formatter" do
    it "applies the formatter for a matched regex pattern" do
      t = MessageTransform.new(/(blue|red|green)/, 'REALLY \1')
      expect(t.process("Your blue shirt matches your green eyes and red face")).to (
        eq "Your REALLY blue shirt matches your REALLY green eyes and REALLY red face"
      )
    end
  end

  describe "#create_highlighter" do
    it "wraps each target in an anchor tag with a matching href" do
      target = "favorite"
      source = "The blue one really is my favorite."
      expectation = 'The blue one really is my <a href="#favorite">favorite</a>.'
      highlighter = MessageTransform.create_highlighter(target)
      result = highlighter.process(source)
      expect(result).to eq expectation
    end

    it "also accepts an alternative value for href" do
      target = "favorite"
      source = "The blue one really is my favorite."
      expectation = 'The blue one really is my <a href="alternative">favorite</a>.'
      highlighter = MessageTransform.create_highlighter(target, "alternative")
      result = highlighter.process(source)
      expect(result).to eq expectation
    end
  end

  describe "#chain_transformers" do
    it "matches both tokens" do
      matchers = [
        MessageTransform.create_highlighter("M"),
        MessageTransform.create_highlighter("K"),
      ]

      original = "This weekend we got some m and K"
      expected = 'This weekend we got some <a href="#m">m</a> and <a href="#k">K</a>'

      expect(MessageTransform.chain_transformers(original, matchers)).to eq expected
    end
  end

  describe "#highlight_tokens" do
    it "loops over the tokens and applies create_highlight" do
      verbs = ["like", "going", "buy", "eat"]
      source = (
        "I like going to Whole Foods during my lunch break " +
        "to buy a salad and eat there."
      )
      formatted = (
        'I <a href="#like">like</a> <a href="#going">going</a> to Whole Foods ' +
        'during my lunch break to <a href="#buy">buy</a> a salad and ' +
        '<a href="#eat">eat</a> there.'
      )
      result = MessageTransform.highlight_tokens(source, verbs)
      expect(result).to eq formatted
    end
  end
end