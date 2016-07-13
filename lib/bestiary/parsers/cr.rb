class Bestiary::Parsers::Cr
  def self.perform(creature)
    bold_elements = creature.css('b')
    bold_elements.each do |bold|
      if bold.text.match('CR ')
        cr_string = bold.text.gsub(/[^\d]/, '')
        return cr_string.to_i
      end
    end

    raise 'could not parse CR'
  end
end
