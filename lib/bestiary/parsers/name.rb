class Bestiary::Parsers::Name
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    name = ''
    if headings?
      name = name_from_headings
    else
      name = name_from_stats
    end

    if last_name_first?(name)
      switch_names(name)
    else
      name
    end
  end

  def headings?
    !creature.css('h1, h2').empty?
  end

  def name_from_headings
    heading = creature.css('h1, h2').first
    heading.text.strip
  end

  def name_from_stats
    stats = creature.css('p')
    stats.each do |stat|
      if stat.text.include?('CR')
        return name_from_stat(stat)
      end
    end
  end

  def name_from_stat(stat)
    title_parts = stat.parent.text.split(' CR')
    title_parts.first.strip
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
