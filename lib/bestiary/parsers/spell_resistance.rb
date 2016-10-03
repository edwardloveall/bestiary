class Bestiary::Parsers::SpellResistance
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

    text = parent_element.text
    match = text.match(/SR (\d+)/)
    match[1].to_i
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/offense/i)
        text.match(/\bSR\b/i)
      end
    end
  end
end
