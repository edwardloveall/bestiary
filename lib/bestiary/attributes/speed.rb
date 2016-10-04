class Bestiary::Attributes::Speed
  attr_reader :title, :feet, :armored, :maneuverability

  def initialize(title:, feet:, armored: false, maneuverability: nil)
    @title = title
    @feet = feet
    @armored = armored
    @maneuverability = maneuverability
  end

  def ==(other)
    title == other.title &&
    feet == other.feet &&
    armored == other.armored &&
    maneuverability == other.maneuverability
  end
end
