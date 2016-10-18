module Bestiary
  RSpec.describe Parsers::Attack do
    describe 'count' do
      context 'when it has no explicit number' do
        it 'returns 1' do
          text = 'bite +10 (1d6+4)'
          parser = Parsers::Attack.new(text)

          result = parser.count

          expect(result).to eq(1)
        end
      end

      context 'when it has an explicit number' do
        it 'returns that number' do
          text = '2 claws +5 (1d4+3)'
          parser = Parsers::Attack.new(text)

          result = parser.count

          expect(result).to eq(2)
        end
      end
    end
  end
end
