class Bestiary::Parsers::Xp
  def self.perform(creature)
    elements = creature.css('p')
    elements.each do |bold|
      if bold.text.match('XP ')
        xp_string = bold.text.gsub(/(XP |,)/, '')
        return xp_string.to_i
      end
    end

    raise 'could not parse XP'
  end
end
