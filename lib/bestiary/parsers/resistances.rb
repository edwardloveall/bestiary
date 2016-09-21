class Bestiary::Parsers::Resistances
  attr_reader :creature
  SCANNED_TOO_FAR = /\Aoffense\Z/i
  RESIST_SIGNATURE = /\bResist\b [\w\s]+ \d/i
  RESISTANCE_SIGNATURE = /(.+) (\d+)/
  ABILITY_SEPARATORS = /;|\Z|SR|Immune|Resist|DR|\(/
  RESISTANCE_SEPARATORS = /,|and|or/

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?

    text = parent_element.text
    resistance_attrs(text).map do |resist_attr|
      match = resist_attr.match(RESISTANCE_SIGNATURE)
      title = match[1]
      bonus = match[2].to_i
      Bestiary::Attributes::Resistance.new(title: title, bonus: bonus)
    end
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(SCANNED_TOO_FAR)
        text.match(RESIST_SIGNATURE)
      end
    end
  end

  def resistance_attrs(text)
    scanner = StringScanner.new(text)
    scanner.skip_until(/\bResist\b/i)
    scanner.scan_until(ABILITY_SEPARATORS)
           .sub(scanner.matched, '')
           .split(RESISTANCE_SEPARATORS)
           .map(&:strip)
  end
end
