class Bestiary::Attributes::Sense
  attr_reader :title, :value, :unit

  def initialize(title:, value: nil, unit: nil)
    @title = title
    @value = value
    @unit = unit
  end

  def to_s
    if value_and_unit?
      "#{title}: #{value} #{unit}"
    elsif value?
      "#{title}: #{value}"
    else
      title
    end
  end

  def value_and_unit?
    value? && !unit.nil?
  end

  def value?
    !value.nil?
  end
end
