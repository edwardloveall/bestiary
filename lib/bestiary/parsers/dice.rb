class Bestiary::Parsers::Dice
  DIE_REGEX = /\d+d\d+/
  BONUS_REGEX = /[+\-]\d+/

  attr_reader :string

  def self.perform(string)
    new(string).perform
  end

  def initialize(string)
    @string = string
  end

  def perform
    die_strings.map do |die_string|
      parts = die_string.partition(/d\d+/)
      count = parts[0].to_i
      sides = parts[1].sub('d', '').to_i
      bonus = parts[2].to_i
      Bestiary::Models::Die.new(count: count, sides: sides, bonus: bonus)
    end
  end

  def die_strings
    scanner = StringScanner.new(string)
    strings = []
    while !scanner.eos?
      if scanner.scan_until(DIE_REGEX)
        strings << scanner.matched
      elsif scanner.scan(BONUS_REGEX)
        if !strings.empty?
          strings[-1] += scanner.matched
        end
      else
        scanner.getch
      end
    end

    strings
  end
end
