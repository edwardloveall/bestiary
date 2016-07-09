class Parsers::Alignment
  ALIGNMENTS = %w(LG LN LE NG N NE CG CN CE).freeze
  attr_reader :stat_block

  def self.perform(creature)
    new.perform(creature)
  end

  def perform(creature)
    all_stats = creature.css('p.stat-block-1')
    all_stats.each do |stat|
      stat.text.split(' ').each do |stat_part|
        if ALIGNMENTS.include?(stat_part)
          return stat_part
        end
      end
    end
  end
end
