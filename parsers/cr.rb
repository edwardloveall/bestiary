class Parsers::Cr
  def self.perform(creature)
    cr_string = creature.at('.stat-block-cr').text
    cr_string.gsub(/(CR )/, '').to_i
  end
end
