class Parsers::Senses
  ATTRIBUTE_REGEXS = [
    /(?<title>Perception) (?<value>(\+|-)\d+)/i,
    /(?<title>blindsense) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>blindsight) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>darkvision) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>greensight) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>keen scent)/i,
    /(?<title>lifesense)/i,
    /(?<title>low-light vision)/i,
    /(?<title>mistsight)/i,
    /(?<title>scent)/i,
    /(?<title>see in darkness)/i,
    /(?<title>thoughtsense) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>tremorsense) (?<value>\d+) (?<unit>ft\.)/i,
    /(?<title>x-ray vision)/i
  ].freeze

  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    parent = parent_element
    text = senses_text(parent)
    individual_senses(text).map do |sense|
      Attributes::Sense.new(sense_attributes(sense))
    end
  end

  def parent_element
    bold_elements = creature.css('b')
    bold_elements.each do |element|
      text = element.text.strip
      if text == 'Senses'
        return element.parent
      end
    end
  end

  def senses_text(parent)
    text = parent.text
    text.split('Senses').last
  end

  def individual_senses(text)
    text.split(';')
  end

  def sense_attributes(sense)
    ATTRIBUTE_REGEXS.each do |regex|
      match = regex.match(sense)
      if match
        return {
          title: match[1].capitalize,
          value: match[2].to_i,
          unit: match[3]
        }
      end
    end
  end
end
