class Bestiary::Parsers::Creature
  def self.perform(page)
    new.perform(page)
  end

  def perform(dom)
    content = dom.at('div.body')
    headers = content.css('h1')
    creatures = []

    headers.each do |header|
      fragment = Nokogiri::HTML::DocumentFragment.parse(header.to_s)
      element = header
      loop do
        element = element.next
        break if element.nil?
        break if h1?(element)
        fragment.add_child(element.dup)
      end

      if enough_attributes?(fragment)
        creatures << fragment
      end
    end

    creatures
  end

  def h1?(element)
    element.name == 'h1'
  end

  def enough_attributes?(fragment)
    fragment.css('p.stat-block-1').length > 10
  end
end
