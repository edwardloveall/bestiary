class Bestiary::Parsers::Type
  TYPES = [
    'aberration',
    'animal',
    'construct',
    'dragon',
    'fey',
    'humanoid',
    'magical beast',
    'monstrous humanoid',
    'ooze',
    'outsider',
    'plant',
    'undead',
    'vermin'
  ].freeze

  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    title = primary_type
    Bestiary::Attributes::Type.new(title: title)
  end

  def primary_type
    type_regexp = Regexp.union(TYPES)
    stats = creature.css('p.stat-block-1')
    stats.each do |stat|
      match = stat.text.match(type_regexp)
      if match
        return match[0]
      end
    end
  end
end
