class Bestiary::Parsers::Immunities
  attr_reader :creature

  SCANNED_TOO_FAR = /\Aoffense\Z/i
  IMMUNE_SIGNATURE = /Immune/i
  ABILITY_SEPARATORS = /;|\Z|SR|Immune|Resist|DR|\(/
  COMMA_LIKE = /[,;]/

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
    scanner = StringScanner.new(text)
    scanner.skip_until(IMMUNE_SIGNATURE)
    scanner.scan_until(ABILITY_SEPARATORS)
           .sub(scanner.matched, '')
           .split(COMMA_LIKE)
           .map(&:strip)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(SCANNED_TOO_FAR)
        text.match(IMMUNE_SIGNATURE)
      end
    end
  end
end
