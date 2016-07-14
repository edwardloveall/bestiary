module Bestiary
  class Parsers::Aura
    AURA_REGEXES = {
      feet: /(\d+) (feet|ft\.)/i,
      dc: /DC (\d+)/i,
      rounds: /(\d+) rounds/i,
      minutes: /(\d+) minutes/i
    }.freeze
    RPAREN = '('.freeze
    LPAREN = ')'.freeze

    attr_reader :creature

    def self.perform(creature)
      new(creature).perform
    end

    def initialize(creature)
      @creature = creature
    end

    def perform
      parent = parent_element
      return [] if parent.nil?
      auras = aura_texts(parent)
      auras.map do |aura|
        if contains_attributes?(aura)
          Attributes::Aura.new(aura_attributes(aura))
        else
          Attributes::Aura.new(title: aura)
        end
      end
    end

    def parent_element
      bold_elements = creature.css('b')
      bold_elements.each do |element|
        text = element.text.strip
        if text == 'Aura'
          return element.parent
        end
      end
      return nil
    end

    def aura_texts(element)
      auras = []
      buffer = ''
      scanner = StringScanner.new(element.text)
      scanner.skip_until(/Aura /)
      while !scanner.eos?
        buffer += scanner.scan_until(/,|\z/)
        if closed_parentheticals(buffer)
          auras << buffer.dup
          buffer.clear
        end
      end
      auras.map { |a| a.strip.sub(/,\z/, '') }
    end

    def closed_parentheticals(string)
      string.count(RPAREN) == string.count(LPAREN)
    end

    def contains_attributes?(text)
      text.include?('(')
    end

    def aura_attributes(text)
      attribtes = {}
      attribtes[:title] = text.split('(').first.strip
      attribtes.merge!(feet_parser(text))
      attribtes.merge!(dc_parser(text))
      attribtes.merge!(rounds_parser(text))
      attribtes.merge!(minutes_parser(text))
      if !attribtes[:title].nil?
        return attribtes
      end
      puts "could not match aura: #{text}"
    end

    def feet_parser(text)
      match = text.match(AURA_REGEXES[:feet])
      if match
        { feet: match[1].to_i }
      else
        {}
      end
    end

    def dc_parser(text)
      match = text.match(AURA_REGEXES[:dc])
      if match
        { dc: match[1].to_i }
      else
        {}
      end
    end

    def rounds_parser(text)
      match = text.match(AURA_REGEXES[:rounds])
      if match
        { rounds: match[1].to_i }
      else
        {}
      end
    end

    def minutes_parser(text)
      match = text.match(AURA_REGEXES[:minutes])
      if match
        { minutes: match[1].to_i }
      else
        {}
      end
    end
  end
end
