class Bestiary::Parsers::DamageReduction
  attr_reader :creature

  DR_SIGNATURE = /DR \d{1,2}/
  ABILITY_SEPARATORS = /;|\Z|SR|Immune|Resist|DR|\(/
  DIGITS_WITH_TEXT = /(\d+)\/(.+)/
  COMMA_LIKE = /[,;]/
  HYPHEN_LIKE = /[—–]/
  EXCEPTION_SEPARATORS = /\b(?:and|or)\b/
  SCANNED_TOO_FAR = /\Aoffense\Z/i

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

    dr_attrs = attributes(parent_element.text)
    Bestiary::Attributes::DamageReduction.new(dr_attrs)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(SCANNED_TOO_FAR)
        text.match(DR_SIGNATURE)
      end
    end
  end

  def attributes(text)
    scanner = StringScanner.new(text)
    scanner.skip_until(/DR/)
    dr_text = scanner.scan_until(ABILITY_SEPARATORS)
                     .sub(scanner.matched, '')
    match = dr_text.strip.match(DIGITS_WITH_TEXT)
    exceptions = match[2].gsub(COMMA_LIKE, '')
                         .sub(HYPHEN_LIKE, '')
                         .split(EXCEPTION_SEPARATORS)
                         .map(&:strip)
    { amount: match[1].to_i, exceptions: exceptions }
  end
end
