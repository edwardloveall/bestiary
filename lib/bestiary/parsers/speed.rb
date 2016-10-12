class Bestiary::Parsers::Speed
  MANEUVERABILITY = /(clumsy|poor|average|good|perfect)/
  FEET_SIGNATURE = /\bft\.?/
  CONDITION_SIGNATURE = /\b(in|without)\b (armor|chainmail|haste)/

  attr_reader :creature

  def initialize(creature)
    @creature = creature
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
end
