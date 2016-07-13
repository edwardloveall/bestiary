class Parsers::Type
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

  def self.perform(creature)
    new.perform(creature)
  end

  def perform(creature)
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
