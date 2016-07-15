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
    string = title
    attrs = []
    attrs << "DC #{dc}" if dc
    attrs << "#{feet} feet" if feet
    attrs << "#{rounds} rounds" if rounds
    attrs << "#{minutes} minutes" if minutes
    if !attrs.empty?
      string += " (#{attrs.join(', ')})"
    end
    string
  end
end
