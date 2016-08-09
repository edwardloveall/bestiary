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

  def parent_element
    @parent_element ||= begin
      type_regexp = Regexp.union(TYPES)
      stats = creature.css('p.stat-block-1')
      stats.detect do |stat|
        !stat.text.match(type_regexp).nil?
      end
    end
  end

  def primary_type
    text = parent_element.text
    type_regexp = Regexp.union(TYPES)
    match = text.match(type_regexp)
    if match
      return match[0]
    end
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
