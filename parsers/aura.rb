class Parsers::Aura
  AURA_REGEXS = [
    /(?<title>emotion) \((DC (?<dc>\d+))\)/i,
    /(?<title>fear aura) \(((?<feet>\d+) ft.), (DC (?<dc>\d+))\)/i,
    /(?<title>frightful presence) \(((?<feet>\d+) ft.), (DC (?<dc>\d+))\)/i,
    /(?<title>mental static) \((DC (?<dc>\d+))\)/i,
    /(?<title>stench) \((DC (?<dc>\d+)), ((?<rounds>\d+) rounds)\)/i,
    /(?<title>unnatural aura) \(((?<feet>\d+) ft.)\)/i,
    /(?<title>faithlessness) \(((?<feet>\d+) ft.)\)/i
  ].freeze
  INTEGER_KEYS = [:feet, :dc, :rounds].freeze

  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    parent = parent_element
    return if parent.nil?
    text = aura_text(parent)
    Attributes::Aura.new(aura_attributes(text))
  end

  def parent_element
    bold_elements = creature.css('b')
    bold_elements.each do |element|
      text = element.text.strip
      if text == 'Aura'
        return element.parent
      end
    end
    return nil
  end

  def aura_text(element)
    element.text.split('Aura').last
  end

  def aura_attributes(text)
    AURA_REGEXS.each do |regex|
      match = regex.match(text)
      if match
        keys = match.names.map(&:to_sym)
        values = match.captures
        values[1..-1] = values[1..-1].map(&:to_i)
        return keys.zip(values).to_h
      end
    end
    puts "could not match aura: #{text}"
  end
end
