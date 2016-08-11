module Bestiary
  RSpec.describe Attributes::Armor do
    describe '#==' do
      it 'returns true when all attributes are equal' do
        armor_a = Attributes::Armor.new(title: 'ac', bonus: 10)
        armor_b = Attributes::Armor.new(title: 'ac', bonus: 10)

        expect(armor_a).to eq(armor_b)
      end
    end
  end
end
