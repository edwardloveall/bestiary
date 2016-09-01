class Bestiary::Parsers::Reflex
  def self.perform(creature)
    parent = creature.css('p').detect do |stat|
      stat.text.strip.match(/^fort/i)
    end

    match = parent.text
                  .strip
                  .sub('–', '-')
                  .match(/ref ([+\-]\d+)/i)

    if match && match[1]
      match[1].to_i
    end
  end
end
