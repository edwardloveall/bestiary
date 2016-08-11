class Bestiary::Attributes::Armor
  attr_reader :title, :bonus

  def initialize(title:, bonus:)
    @title = title
    @bonus = bonus
  end

  def ==(other)
    title == other.title && bonus == other.bonus
  end
end
