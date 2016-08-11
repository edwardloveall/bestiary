class Bestiary::Parsers::Armor
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    armor_pairs.map do |pair|
      bonus = pair.scan(/[+\-]?\d+/).first
      title = pair.sub(bonus, '').strip
      Bestiary::Attributes::Armor.new(title: title, bonus: bonus.to_i)
    end
  end

  def parent_element
    @parent_element ||= begin
      all_stats = creature.css('p.stat-block-1')
      all_stats.detect do |stat|
        stat.text.strip.match(/^AC /)
      end
    end
  end

  def armor_pairs
    text = parent_element.text
    sanitized = text.downcase
                    .sub(' (', ', ')
                    .sub('; ', ', ')
                    .sub(')', '')
                    .sub('–', '-')
    sanitized.split(', ')
  end
end
