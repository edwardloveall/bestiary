class Bestiary::Parsers::Speed
  MANEUVERABILITY = /(clumsy|poor|average|good|perfect)/
  FEET_SIGNATURE = /\bft\.?/
  CONDITION_SIGNATURE = /\b(in|without)\b (armor|chainmail|haste)/

  attr_reader :creature

  def initialize(creature)
    @creature = creature
  end

  def title(speed)
    matches = speed.strip.match(/([[:alpha:]]+) \d+/)
    return 'movement' if matches.nil?
    matches[1].sub('Speed', 'movement').strip
  end

  def feet(speed)
    match = speed.strip.match(/\d+/)[0]
    match.to_i
  end

  def maneuverability(speed)
    matches = speed.match(MANEUVERABILITY)
    if matches
      matches[0].to_sym
    end
  end

  def divide(text)
    @speeds ||= begin
      speeds = []
      scanner = StringScanner.new(text)

      while scanner.exist?(FEET_SIGNATURE)
        text = ''
        text = scanner.scan_until(FEET_SIGNATURE)
        if text.include?('fly')
          text += scanner.scan_until(MANEUVERABILITY).to_s
        end

        next_scan = scanner.check_until(/ft\.?|\z/)
        if next_scan.match(CONDITION_SIGNATURE)
          text += scanner.scan_until(CONDITION_SIGNATURE)
        end

        speeds << text
      end
      speeds
    end
  end

  def armor_indexes(speeds)
    max_armor_index = speeds.find_index do |speed|
      speed.match(CONDITION_SIGNATURE)
    end

    if max_armor_index.nil?
      return speeds.map { false }
    end

    max_index_without_armor = (max_armor_index / 2).floor

    speeds.map.with_index do |_, index|
      if index <= max_index_without_armor
        false
      elsif index > max_index_without_armor && index <= max_armor_index
        true
      else
        false
      end
    end
  end
end
