class Bestiary::Attributes::Attack
  attr_accessor :count,
                :title,
                :bonuses,
                :damage,
                :critical_range,
                :critical_multiplier,
                :additional_effects

  def initialize(count: 1,
                 title:,
                 bonuses:,
                 damage:,
                 critical_range: 1,
                 critical_multiplier: 2,
                 additional_effects: [])
    @count = count
    @title = title
    @bonuses = bonuses
    @damage = damage
    @critical_range = critical_range
    @critical_multiplier = critical_multiplier
    @additional_effects = additional_effects
  end

  def ==(other)
    count == other.count &&
    title == other.title &&
    bonuses == other.bonuses &&
    damage == other.damage &&
    critical_range == other.critical_range &&
    critical_multiplier == other.critical_multiplier &&
    additional_effects == other.additional_effects
  end
end
