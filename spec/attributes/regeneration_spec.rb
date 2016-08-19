module Bestiary
  RSpec.describe Attributes::Regeneration do
    describe '#==' do
      it 'returns true when all attributes match' do
        regen_a = Attributes::Regeneration.new(amount: 5,
                                               exceptions: %(fire acid))
        regen_b = Attributes::Regeneration.new(amount: 5,
                                               exceptions: %(fire acid))

        expect(regen_a).to eq(regen_b)
      end

      it 'returns false when attributes do not match' do
        regen_a = Attributes::Regeneration.new(amount: 1,
                                               exceptions: %(fire acid))
        regen_b = Attributes::Regeneration.new(amount: 5,
                                               exceptions: %(fire acid))

        expect(regen_a).not_to eq(regen_b)
      end
    end
  end
end
