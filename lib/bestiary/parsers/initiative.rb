class Bestiary::Parsers::Initiative
  def self.perform(creature)
    bold_elements = creature.css('b')
    bold_elements.each do |element|
      text = element.text.strip
      if text == 'Init'
        modifier = element.next.text
        return modifier.gsub(/[^\d|\-]/, '').to_i
      end
    end
  end
end
