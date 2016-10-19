class Bestiary::Parsers::Attack
  INITIAL_COUNT = /\d+\s/
  DIE_SIGNATURE = /\d+d\d+([+\-]\d+)?/
  FORWARD_SLASH = /\//

  attr_reader :attack_text, :scanner

  def initialize(attack_text)
    @attack_text = attack_text.tr('–', '-')
    @scanner = StringScanner.new(@attack_text)
  end

  def count
    scanner.reset
    result = scanner.scan(INITIAL_COUNT) || 1
    result.to_i
  end

  def title
    bonus_sign = /\s[+\-]/
    scanner.reset
    scanner.skip(INITIAL_COUNT)
    text = scanner.scan_until(bonus_sign)
    text.sub(scanner.matched, '')
  end

  def bonuses
    masterwork_signature = /\s?[+\-]\d+/
    bonus_number = /[+\-]\d+/
    scanner.reset
    scanner.skip(INITIAL_COUNT)
    scanner.skip(masterwork_signature)

    scanner.scan_until(bonus_number)
    matches = [scanner.matched]
    while scanner.skip(FORWARD_SLASH)
      matches << scanner.scan(bonus_number)
    end

    matches.map(&:to_i)
  end

  def damage
    scanner.reset
    scanner.scan_until(DIE_SIGNATURE)
    die_text = scanner.matched
    return if die_text.nil?

    dice = Bestiary::Parsers::Dice.perform(die_text)
    if !dice.empty?
      dice.first
    end
  end

  def critical_range
    number_range = /\d+-\d+/
    scanner.reset
    scanner.skip_until(DIE_SIGNATURE)
    return 1 if scanner.scan(FORWARD_SLASH).nil?

    text = scanner.scan(number_range)
    return 1 if text.nil?

    ends = text.split('-').map(&:to_i)
    (ends.first..ends.last).size
  end

  def critical_multiplier
    scanner.reset
    scanner.skip_until(DIE_SIGNATURE)
    return 2 if scanner.scan(FORWARD_SLASH).nil?

    text = scanner.scan(/x\d+/)
    return 2 if text.nil?

    text.sub('x', '').to_i
  end

  def additional_effects
    phrase_signature = /[\w\s]+/
    separators = /and|or/
    plus = /\bplus\s/
    open_parenthesis = /\(/

    scanner.reset
    scanner.skip_until(open_parenthesis)
    scanner.skip(DIE_SIGNATURE)
    scanner.skip_until(plus)

    text = scanner.scan_until(phrase_signature)
    return [] if text.nil?
    text.split(separators).map(&:strip)
  end
end
