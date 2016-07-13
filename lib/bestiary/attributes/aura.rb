class Bestiary::Attributes::Aura
  attr_reader :title, :dc, :feet, :rounds

  def initialize(title:, dc: nil, feet: nil, rounds: nil)
    @title = title
    @dc = dc
    @feet = feet
    @rounds = rounds
  end

  def to_s
    feet_string = feet ? "#{feet} ft" : nil
    dc_string = dc ? "DC #{dc}" : nil
    rounds_string = rounds ? "#{feet} rounds" : nil
    attrs = [feet_string, dc_string, rounds_string].compact.join(', ')
    "#{title} (#{attrs})"
  end
end
