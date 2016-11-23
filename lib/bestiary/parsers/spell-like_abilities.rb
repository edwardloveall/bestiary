class Bestiary::Parsers::SpellLikeAbilities
  SPELL_ABILITIES_SIGNATURE = /\A.*Spell-Like Abilities/i

  attr_accessor :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    abilities(ability_text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/statistics/i)
        text.match(SPELL_ABILITIES_SIGNATURE)
      end
    end
  end

  def ability_text
    element = parent_element
    lines = []
    loop do
      element = element.next
      break if element.nil?
      element_text = element.text.strip
      next if element_text.empty?

      if element_text.match(/\A(\d+\/\w+|At will|Constant)/i)
        lines << element_text.dup
      end
    end

    lines
  end

  def abilities(texts)
    buffer = []
    texts.each do |text|
      sanitized = remove_frequency(text)
      sanitized = remove_parentheticals(sanitized)
      parts = sanitized.split(',')
      parts = remove_special_characters(parts)
      parts.map!(&:strip)
      buffer << parts
    end
    buffer.flatten
  end

  def remove_frequency(text)
    text_until_em_dash = /.+—/
    text.sub(text_until_em_dash, '')
  end

  def remove_parentheticals(text)
    inside_parenthesis_and_space_before = /\s*\(.+\)/
    text.gsub(inside_parenthesis_and_space_before, '')
  end

  def remove_special_characters(parts)
    non_alpha_digits_spaces = /[^a-zA-Z\d\s]/
    parts.map do |part|
      part.gsub(non_alpha_digits_spaces, '')
    end
  end
end
