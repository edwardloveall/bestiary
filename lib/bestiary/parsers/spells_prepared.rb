class Bestiary::Parsers::SpellsPrepared
  attr_accessor :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    spells(spell_text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/statistics/i)
        text.match(/Spells Known/i)
      end
    end
  end

  def spell_text
    element = parent_element
    lines = []
    loop do
      element = element.next
      break if element.nil?
      element_text = element.text.strip
      next if element_text.empty?

      if element_text.match(/\A\d/i)
        lines << element_text.dup
      end
    end

    lines
  end

  def spells(lines)
    buffer = []
    lines.each do |line|
      sanitized = remove_level_and_frequency(line)
      sanitized = remove_parentheticals(sanitized)
      parts = sanitized.split(',')
      parts.map! { |part| remove_special_characters(part) }
      parts.map!(&:strip)
      parts.delete_if { |text| ambiguous_spell?(text) }
      buffer << parts
    end
    buffer.flatten
  end

  def remove_level_and_frequency(line)
    text_until_em_dash = /.+—/
    line.sub(text_until_em_dash, '')
  end

  def remove_parentheticals(line)
    inside_parenthesis_and_space_before = /\s*\(.+\)/
    line.gsub(inside_parenthesis_and_space_before, '')
  end

  def ambiguous_spell?(text)
    n_more = /\d more/
    text.match(n_more)
  end

  def remove_special_characters(text)
    non_alpha_digits_spaces = /[^a-zA-Z\d\s\/]/
    text.gsub(non_alpha_digits_spaces, '')
  end
end
