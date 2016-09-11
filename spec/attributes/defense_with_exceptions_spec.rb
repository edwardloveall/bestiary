module Bestiary
  RSpec.describe Attributes::DefenseWithExceptions do
    describe '#==' do
      it 'returns true when all attributes match' do
        defense_a = Attributes::DefenseWithExceptions.new(amount: 5,
                                                          exceptions: %(fire acid))
        defense_b = Attributes::DefenseWithExceptions.new(amount: 5,
                                                          exceptions: %(fire acid))

        expect(defense_a).to eq(defense_b)
      end

      it 'returns false when attributes do not match' do
        defense_a = Attributes::DefenseWithExceptions.new(amount: 1,
                                                          exceptions: %(fire acid))
        defense_b = Attributes::DefenseWithExceptions.new(amount: 5,
                                                          exceptions: %(fire acid))

        expect(defense_a).not_to eq(defense_b)
      end
    end
  end
end
