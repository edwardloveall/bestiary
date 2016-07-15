class Bestiary::Attributes::Aura
  attr_reader :title, :dc, :feet, :rounds, :minutes

  def initialize(title:, dc: nil, feet: nil, rounds: nil, minutes: nil)
    @title = title
    @dc = dc
    @feet = feet
    @rounds = rounds
    @minutes = minutes
  end

  def ==(other)
    (
      title == other.title &&
      dc == other.dc &&
      feet == other.feet &&
      rounds == other.rounds &&
      minutes == other.minutes
    )
  end

  def to_s
    feet_string = feet ? "#{feet} ft" : nil
    dc_string = dc ? "DC #{dc}" : nil
    rounds_string = rounds ? "#{feet} rounds" : nil
    attrs = [feet_string, dc_string, rounds_string].compact.join(', ')
    "#{title} (#{attrs})"
  end
end
