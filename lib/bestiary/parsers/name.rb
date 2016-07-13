class Bestiary::Parsers::Name
  def self.perform(creature)
    name_group = creature.at('h1')
    name_group.children.first.text.strip
  end
end
