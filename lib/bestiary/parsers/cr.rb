class Bestiary::Parsers::Cr
  def self.perform(creature)
    stat_elements = creature.css('p')
    stat_elements.each do |stat|
      if stat.text.match('CR ')
        return stat.text.gsub(/[^\d\/]/, '')
      end
    end
    'not found'
  end
end
