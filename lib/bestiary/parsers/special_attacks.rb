class Bestiary::Parsers::SpecialAttacks
  SCANNED_TOO_FAR = /SPECIAL ABILITIES/
  SPECIAL_ATTACKS_SIGNATURE = /\ASpecial Attacks /i
  MULTIPLE_WORD_AND_SPACE_CHARACTERS = /[\w\s]+/
  SEPARATORS = /,\s|\Z/
  CLOSE_PARENTHESIS = /\)/

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
    parse_attacks(text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(SCANNED_TOO_FAR)
        text.match(SPECIAL_ATTACKS_SIGNATURE)
      end
    end
  end

  def parse_attacks(text)
    scanner = StringScanner.new(text)
    scanner.skip(SPECIAL_ATTACKS_SIGNATURE)
    attacks = []

    while !scanner.eos?
      buffer = scanner.scan_until(MULTIPLE_WORD_AND_SPACE_CHARACTERS)
      scanner.skip_until(SEPARATORS)
      while inside_parenthetical(scanner.rest)
        scanner.skip_until(CLOSE_PARENTHESIS)
        scanner.skip_until(SEPARATORS)
      end
      attacks << buffer.strip
    end

    attacks
  end

  def inside_parenthetical(text)
    text.count('(') != text.count(')')
  end
end
