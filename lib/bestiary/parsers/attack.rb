class Bestiary::Parsers::Attack
  INITIAL_COUNT = /\d+\s/
  DIE_SIGNATURE = /\d+d\d+([+\-]\d+)?/
  FORWARD_SLASH = /\//
  MASTERWORK_SIGNATURE = /\s?[+\-]\d+/
  OPEN_PARENTHESIS = /\(/

  attr_reader :attack_text, :scanner

  def self.perform(attack_text)
    new(attack_text).perform
  end

  def initialize(attack_text)
    @attack_text = attack_text.tr('–', '-')
    @scanner = StringScanner.new(@attack_text)
  end

  def perform
    Bestiary::Attributes::Attack.new(
      count: count,
      title: title,
      bonuses: bonuses,
      damage: damage,
      critical_range: critical_range,
      critical_multiplier: critical_multiplier,
      additional_effects: additional_effects
    )
  end

  def count
    scanner.reset
    result = scanner.scan(INITIAL_COUNT)

    if result.nil?
      scanner.skip(MASTERWORK_SIGNATURE)
      text = scanner.scan_until(OPEN_PARENTHESIS).to_s
      result = text.count('/') + 1
    end

    result.to_i
  end

  def title
    end_of_title = /\s([+\-]|\()/
    scanner.reset
    scanner.skip(INITIAL_COUNT)
    text = scanner.scan_until(end_of_title)
    text.sub(scanner.matched, '')
  end

  def bonuses
    bonus_number = /[+\-]\d+/
    scanner.reset
    scanner.skip(INITIAL_COUNT)
    scanner.skip(MASTERWORK_SIGNATURE)

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
    plus = /\ssulp/
    separators = /and|or/
    reversed_text = attack_text.reverse
    reverse_scanner = StringScanner.new(reversed_text)

    reverse_scanner.skip(/\)/)
    text = reverse_scanner.scan_until(plus)
    if text.nil?
      text = reverse_scanner.scan(/[a-zA-Z\s]+/)
    end

    return [] if text.nil?

    text.sub(plus, '')
        .reverse
        .split(separators)
        .map(&:strip)
  end
end
