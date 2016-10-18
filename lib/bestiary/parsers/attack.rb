class Bestiary::Parsers::Attack
  INITIAL_COUNT = /\d+\s/
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
end
