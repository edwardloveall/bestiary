class Parsers::Size
  SIZES = %w(Fine
             Diminutive
             Tiny
             Small
             Medium
             Large
             Huge
             Gargantuan
             Colossal).freeze
  attr_reader :stat_block

  def self.perform(creature)
    new.perform(creature)
  end

  def perform(creature)
    all_stats = creature.css('p.stat-block-1')
    all_stats.each do |stat|
      stat.text.split(' ').each do |stat_part|
        if SIZES.include?(stat_part)
          return stat_part
        end
      end
    end
  end
end
