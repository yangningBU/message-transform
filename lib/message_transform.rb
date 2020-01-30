class MessageTransform
  def initialize(pattern, formatter, name = nil)
    @pattern = pattern
    @formatter = formatter
    @name = name
  end

  def process(message)
    if message =~ @pattern
      message = message.gsub(@pattern, @formatter)
    end
    message
  end

  def self.create_highlighter(string, target = nil)
    sanitized = string.to_s.downcase
    target ||= "#" + sanitized
    MessageTransform.new(
      /(.*)\b(#{sanitized})\b(.*)/i,
      '\1<a href="' + target + '">\2</a>\3',
      "Highlight #{sanitized}"
    )
  end

  def self.chain_transformers(original, transformers)
    finished = transformers.reduce(original) do |processed, transformer|
      processed = transformer.process(processed)
    end
  end

  def self.highlight_tokens(original, tokens)
    chain_transformers(original, tokens.map{|token| create_highlighter(token) })
  end
end