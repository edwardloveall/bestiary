class Bestiary::Parsers::Reach
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
    space = text.split(/[;,] /).last
    space.sub('Reach ', '').to_i
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text
        break if text.strip.match(/STATISTICS/)
        text.match(/reach \d+ f/i)
      end
    end
  end
end
