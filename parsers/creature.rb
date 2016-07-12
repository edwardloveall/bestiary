class Parsers::Creature
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
      creatures << fragment
    end

    creatures
  end

  def h1?(element)
    element.name == 'h1'
  end
end
