class Bestiary::Parsers::Space
  attr_accessor :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    text = parent_element.text
    feet(text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/STATISTICS/)
        text.match(/\ASpace/i)
      end
    end
  end

  def feet(text)
    space = text.split(/[;,]/).first
    space.sub('-1/2', '.5')
         .sub('Space ', '')
         .to_f
  end
end
