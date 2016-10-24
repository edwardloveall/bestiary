class Bestiary::Parsers::Melee
  SCANNED_TOO_FAR = /\A(Special Attack|STATISTICS|SPECIAL ABILITIES|TACTICS)/i
  MELEE_SIGNATURE = /\AMelee /
  SEPARATOR = /, | or | and /

  attr_accessor :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    scanner = StringScanner.new(parent_text)
    scanner.skip(/Melee /)
    attacks = []
    while !scanner.eos?
      attack = scanner.scan_until(/\)|\Z/)
      if attack.count('(') != attack.count(')')
        next
      end
      attacks << attack.dup
      scanner.skip(SEPARATOR)
    end

    attacks.map do |attack|
      Bestiary::Parsers::Attack.perform(attack)
    end
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        break if stat.text.match(SCANNED_TOO_FAR)
        stat.text.match(MELEE_SIGNATURE)
      end
    end
  end

  def parent_text
    element = parent_element
    text = element.text

    loop do
      element = element.next_sibling
      break if element.nil?
      next if element.name == 'text'
      attribute_titles = element.css('strong, b')
      break if !attribute_titles.empty?
      break if element.text.match(SCANNED_TOO_FAR)
      text += " #{element.text}"
    end

    text.strip
  end
end
