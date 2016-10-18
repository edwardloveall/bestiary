class Bestiary::Parsers::Attack
  INITIAL_COUNT = /\d+\s/

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
end
