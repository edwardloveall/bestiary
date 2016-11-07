class Bestiary::Parsers::Creature
  MIN_ATTR_COUNT = 15
  attr_reader :dom

  def self.perform(dom)
    new(dom).perform
  end

  def initialize(dom)
    @dom = dom
  end

  def perform
    creatures = []

    headers.each do |header|
      fragment = Nokogiri::HTML::DocumentFragment.parse(header.to_s)
      element = header
      loop do
        element = element.next
        break if element.nil?
        break if heading?(element)
        fragment.add_child(element.dup)
      end

      if enough_attributes?(fragment)
        creatures << fragment
      end
    end

    creatures
  end

  def headers
    content = dom.at('div.body')
    content.css('p').select do |stat|
      stat.text.strip.match(/CR\s?\d+(\/\d)?\Z/)
    end
  end

  def heading?(element)
    element.name == 'h1' || element.name == 'h2'
  end

  def enough_attributes?(fragment)
    attr_text = fragment.css('b, strong').map(&:text)
    valid_attrs = %w(Init Senses AC hp Fort Ref Will Speed Melee Space Reach Str
                     Dex Con Int Wis Cha Base Atk CMB CMD Feats Skills Languages
                     Environment Organization Treasure Defensive\ Abilities
                     Immune Special\ Attacks)
    included_attrs = valid_attrs.select { |a| attr_text.include?(a) }
    included_attrs.count >= MIN_ATTR_COUNT
  end
end
