class Bestiary::Attributes::Hp
  attr_reader :value, :dice

  def initialize(value:, dice:)
    @value = value
    @dice = dice
  end

  def ==(other)
    value == other.value &&
    dice == other.dice
  end
end
