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

  SUBTYPES = [
    'adlet',
    'aeon',
    'aether',
    'agathion',
    'air',
    'android',
    'angel',
    'aquatic',
    'archon',
    'asura',
    'augmented',
    'azata',
    'behemoth',
    'catfolk',
    'changeling',
    'chaotic',
    'clockwork',
    'cold',
    'colossus',
    'daemon',
    'dark folk',
    'deep one',
    'demodand',
    'demon',
    'devil',
    'div',
    'dwarf',
    'earth',
    'elemental',
    'elf',
    'evil',
    'extraplanar',
    'fire',
    'giant',
    'gnome',
    'goblinoid',
    'good',
    'gray',
    'great old one',
    'grippli',
    'halfling',
    'human',
    'incorporeal',
    'inevitable',
    'kaiju',
    'kami',
    'kasatha',
    'kitsune',
    'kyton',
    'lawful',
    'leshy',
    'manasaputra',
    'mythic',
    'native',
    'nightshade',
    'oni',
    'orc',
    'phantom',
    'protean',
    'psychopomp',
    'qlippoth',
    'rakshasa',
    'ratfolk',
    'reptilian',
    'robot',
    'sahkil',
    'samsaran',
    'sasquatch',
    'shapechanger',
    'skinwalker',
    'swarm',
    'udaeus',
    'vanara',
    'vishkanya',
    'water',
    'wayang'
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
    subtypes
    Bestiary::Attributes::Type.new(title: title, subtypes: subtypes)
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

  def subtypes
    types = []
    text = parent_element.text
    SUBTYPES.each do |subtype|
      if text.include?(subtype)
        types << subtype
      end
    end

    types
  end
end
