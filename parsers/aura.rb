class Parsers::Aura
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    parent = parent_element
    return [] if parent.nil?
    auras = aura_texts(parent)
    auras.map do |aura|
      if contains_attributes?(aura)
        Attributes::Aura.new(aura_attributes(aura))
      else
        Attributes::Aura.new(title: aura)
      end
    end
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

  def aura_texts(element)
    all_text = element.text.split('Aura').last
    auras = all_text.split(',')
    auras.map(&:strip)
  end

  def contains_attributes?(text)
    text.include?('(')
  end

  def aura_attributes(text)
    attribtes = {}
    attribtes[:title] = text.split('(').first.strip
    attribtes.merge!(feet_parser(text))
    attribtes.merge!(dc_parser(text))
    attribtes.merge!(rounds_parser(text))
    if !attribtes[:title].nil?
      return attribtes
    end
    puts "could not match aura: #{text}"
  end

  def feet_parser(text)
    match = text.match(/(\d+) (feet|ft\.)/i)
    if match
      { feet: match[1].to_i }
    else
      {}
    end
  end

  def dc_parser(text)
    match = text.match(/DC (\d+)/i)
    if match
      { dc: match[1].to_i }
    else
      {}
    end
  end

  def rounds_parser(text)
    match = text.match(/(\d.+) rounds/i)
    if match
      { rounds: match[1] }
    else
      {}
    end
  end
end
