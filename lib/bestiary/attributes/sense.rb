class Bestiary::Attributes::Sense
  attr_reader :title, :value, :unit

  def initialize(title:, value: nil, unit: nil)
    @title = title
    @value = value
    @unit = unit
  end

  def to_s
    if !value.nil? && !unit.nil?
      "#{title}: #{value} #{unit}"
    elsif !value.nil?
      "#{title}: #{value}"
    else
      title
    end
  end
end
