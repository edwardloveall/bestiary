module Bestiary
  RSpec.describe Models::Die do
    describe '#==' do
      it 'returns true when both dies are equal' do
        die_a = Models::Die.new(count: 1, sides: 6, bonus: 3)
        die_b = Models::Die.new(count: 1, sides: 6, bonus: 3)

        expect(die_a).to eq(die_b)
      end
    end
  end
end
