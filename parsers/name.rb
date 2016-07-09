class Parsers::Name
  def self.perform(creature)
    name_group = creature.at('.stat-block-title')
    name_group.children.first.text.strip
  end
end
