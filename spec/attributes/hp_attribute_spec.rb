module Bestiary
  RSpec.describe Attributes::Hp do
    describe '#==' do
      it 'returns true when the two objects have the same values' do
        dice = [Models::Die.new(count: 9, sides: 10, bonus: 54)]
        hp_a = Attributes::Hp.new(value: 103, dice: dice.dup)
        hp_b = Attributes::Hp.new(value: 103, dice: dice.dup)

        expect(hp_a).to eq(hp_b)
      end
    end
  end
end
