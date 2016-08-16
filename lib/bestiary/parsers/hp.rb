class Bestiary::Parsers::Hp
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    Bestiary::Attributes::Hp.new(value: value, dice: dice)
  end

  def value
    text = parent_element.text
    matches = text.match(/^hp (\d+)/)
    if matches
      matches[1].to_i
    end
  end

  def dice
    text = parent_element.text
    matches = text.match(/\(.+\)/)
    if matches
      Bestiary::Parsers::Dice.perform(matches[0])
    end
  end

  def parent_element
    @parent_element ||= begin
      all_stats = creature.css('p.stat-block-1')
      all_stats.detect do |stat|
        stat.text.strip.match(/^hp /i)
      end
    end
  end
end
