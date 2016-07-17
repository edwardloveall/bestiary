class Bestiary::Parsers::Name
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    name_from_headings
  end

  def name_from_headings
    heading = creature.css('h1, h2').first
    heading.text.strip
  end
end
