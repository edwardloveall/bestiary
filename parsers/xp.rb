class Parsers::Xp
  def self.perform(creature)
    xp_string = creature.at('.stat-block-xp').text
    xp_string.gsub(/(XP |,)/, '').to_i
  end
end
