class Bestiary::Models::Die
  attr_reader :count, :sides, :bonus

  def initialize(count: 1, sides:, bonus: 0)
    @count = count
    @sides = sides
    @bonus = bonus
  end

  def ==(other)
    return count == other.count &&
           sides == other.sides &&
           bonus == other.bonus
  end
end
