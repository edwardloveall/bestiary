class Bestiary::Parsers::Weaknesses
  WEAKNESS_SIGNATURE = /\bWeaknesses|Weakness\b/i
  COMMA_LIKE = /[,;]/

  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    if parent_element.nil?
      return
    end

    weaknesses(parent_element.text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/offense/i)
        text.match(WEAKNESS_SIGNATURE)
      end
    end
  end

  def weaknesses(text)
    scanner = StringScanner.new(text)
    scanner.scan_until(WEAKNESS_SIGNATURE)
    scanner.post_match
           .split(COMMA_LIKE)
           .map(&:strip)
  end
end
