class Bestiary::Parsers::FastHealing
  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    if parent_element.nil?
      return
    end
    amount(parent_element.text)
  end

  def parent_element
    @parent ||= creature.css('p').find do |stat|
      stat.text.match(/^hp.+fast healing \d*/i)
    end
  end

  def amount(text)
    @amount ||= begin
      match = text.match(/fast healing (\d+)/)
      if match
        match[1].to_i
      end
    end
  end
end
