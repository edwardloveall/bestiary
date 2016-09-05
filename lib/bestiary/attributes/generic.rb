class Bestiary::Attributes::Generic
  attr_reader :title, :bonus

  def initialize(title:, bonus: nil)
    @title = title
    @bonus = bonus
  end

  def ==(other)
    title == other.title && bonus == other.bonus
  end
end
