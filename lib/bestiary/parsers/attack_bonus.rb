class Bestiary::Parsers::AttackBonus
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    text = parent_element.text
    sanitized = text.gsub(/–/, '-')
    matches = sanitized.match(/Base Atk ([–+]\d+)/)

    if matches && matches[1]
      matches[1].to_i
    end
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/\ASpecial Abilities/i)
        text.match(/\ABase Atk/i)
      end
    end
  end
end
