class Bestiary::Parsers::AbilityScores
  NOT_APPLICABLE = '—'.freeze
  SOFT_HYPHEN = '­'.freeze

  attr_reader :creature

  def self.perform(creature)
    new(creature).perform
  end

  def initialize(creature)
    @creature = creature
  end

  def perform
    return if parent_element.nil?
    text = sanitize(parent_text)
    abilities(text)
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        text = stat.text.strip
        break if text == 'Ecology'
        break if text == 'Special Abilities'
        text.match(/\AStr\s/i)
      end
    end
  end

  def parent_text
    element = parent_element
    text = element.text
    loop do
      if text.include?('Str') &&
         text.include?('Dex') &&
         text.include?('Con') &&
         text.include?('Int') &&
         text.include?('Wis') &&
         text.include?('Cha')
        break
      else
        element = element.next
        text += element.text.strip
      end
    end
    text
  end

  def sanitize(text)
    text.gsub(', ', ',')
        .gsub(SOFT_HYPHEN, '')
  end

  def abilities(text)
    text.split(',').each_with_object({}) do |ability, hash|
      parts = ability.split(' ')
      name = parts[0].downcase.to_sym
      hash[name] = score(parts[1])
    end
  end

  def score(text)
    if text == NOT_APPLICABLE
      nil
    else
      text.to_i
    end
  end
end
