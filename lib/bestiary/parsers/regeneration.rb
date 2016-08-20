class Bestiary::Parsers::Regeneration
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
    text = parent_element.text

    Bestiary::Attributes::Regeneration.new(amount: amount(text),
                                           exceptions: exceptions(text))
  end

  def parent_element
    @parent ||= creature.css('p').find do |stat|
      stat.text.match(/^hp.+regeneration/i)
    end
  end

  def amount(text)
    @amount ||= begin
      match = text.match(/regeneration (\d+)/)
      if match
        match[1].to_i
      end
    end
  end

  def exceptions(text)
    exceptions_text = text.split(%r{regeneration \d+})
                          .last
                          .strip
                          .sub('(', '')
                          .sub(')', '')
    exceptions = exceptions_text.split(/, or |, and |, |; | or | and /)
    exceptions.delete_if { |ex| ex.match(/^see/) }
  end
end
