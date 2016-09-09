class Bestiary::Parsers::DefensiveAbilities
  ABILITY_GROUP_SEPARATORS = [
    /;/,
    /DR/,
    /Immune/,
    /Resist/,
    /\Z/
  ].freeze
  # regex from http://stackoverflow.com/a/18424594/638966
  ABILITY_SEAPARATOR = %r{((?>[^,(]+|(\((?>[^()]+|\g<-1>)*\)))+)}
  TITLE_CHARS = /[a-zA-Z\-\s]+/
  BONUS_CHARS = /[+\-]?\d+/

  attr_accessor :creature

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

    abilities_text = element_text(parent_element.text)
    individual = individual_abilities(abilities_text)
    individual.map do |ability_text|
      hash = ability_hash(ability_text)
      Bestiary::Attributes::Generic.new(hash)
    end
  end

  def parent_element
    @parent ||= begin
      creature.css('p').find do |stat|
        stat.text.match(/^defensive abilities/i)
      end
    end
  end

  def element_text(text)
    scanner = StringScanner.new(text)
    scanner.scan_until(Regexp.union(ABILITY_GROUP_SEPARATORS))
    match = scanner.pre_match
    match.gsub(/defensive abilities/i, '')
         .strip
         .gsub(/,\Z/, '')
  end

  def individual_abilities(text)
    text.scan(ABILITY_SEAPARATOR).map(&:first)
  end

  def ability_hash(ability_text)
    sanitized_text = ability_text.strip.sub('–', '-')
    scanner = StringScanner.new(sanitized_text)
    title = scanner.scan(TITLE_CHARS)
    bonus_text = scanner.scan(BONUS_CHARS)

    if !bonus_text.nil?
      { title: title.strip, bonus: bonus_text.to_i }
    else
      { title: title.strip }
    end
  end
end
