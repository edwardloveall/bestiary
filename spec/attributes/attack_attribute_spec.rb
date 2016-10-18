module Bestiary
  RSpec.describe Attributes::Attack do
    describe '#==' do
      it 'returns true of the attributes are equal' do
        attack_a = Attributes::Attack.new(
          count: 2,
          title: 'claw',
          bonuses: [26],
          damage: Models::Die.new(count: 1, sides: 10, bonus: 13),
          critical_range: 2,
          critical_multiplier: 2,
          additional_effects: ['pain']
        )
        attack_b = attack_a.dup

        expect(attack_a).to eq(attack_b)
      end

      it 'returns false of the attributes are not equal' do
        attack_a = Attributes::Attack.new(
          count: 2,
          title: 'claw',
          bonuses: [26],
          damage: Models::Die.new(count: 1, sides: 10, bonus: 13),
          critical_range: 2,
          critical_multiplier: 2,
          additional_effects: ['pain']
        )
        attack_b = attack_a.dup
        attack_b.count = 1

        expect(attack_a).not_to eq(attack_b)
      end
    end
  end
end
