class Bestiary::Attributes::Regeneration
  attr_reader :amount, :exceptions

  def initialize(amount:, exceptions:)
    @amount = amount
    @exceptions = exceptions
  end

  def ==(other)
    amount == other.amount && exceptions == other.exceptions
  end
end
