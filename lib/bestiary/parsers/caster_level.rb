class Bestiary::Parsers::CasterLevel
  attr_accessor :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    text = parent_element.text
    match = text.match(/\(CL (\d+)/)
    match[1].to_i
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/statistics/i)
        text.match(/Spell-Like Abilities \(CL/i)
      end
    end
  end
end
