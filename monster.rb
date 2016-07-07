class Monster
  attr_reader :basic, :defense, :offense, :statistics, :ecology, :special

  def initialize(basic:)
    @basic = basic
  end
end
