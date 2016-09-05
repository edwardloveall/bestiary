module Bestiary
  RSpec.describe Attributes::Generic do
    describe '#==' do
      it 'returns true when all attributes match' do
        generic_a = Attributes::Generic.new(title: 'title', bonus: 1)
        generic_b = Attributes::Generic.new(title: 'title', bonus: 1)

        expect(generic_a).to eq(generic_b)
      end
    end
  end
end
