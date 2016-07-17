class Bestiary::Parsers::Name
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    name = name_from_headings

    if last_name_first?(name)
      switch_names(name)
    else
      name
    end
  end

  def name_from_headings
    heading = creature.css('h1, h2').first
    heading.text.strip
  end

  def last_name_first?(name)
    name.include?(', ')
  end

  def switch_names(name)
    parts = name.split(', ')
    switched = [parts.pop] + parts
    switched.join(' ')
  end
end
