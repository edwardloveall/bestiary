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

    describe 'title' do
      it 'returns text before the attack bonuses and after the count' do
        text = 'bite +10 (1d6+4)'
        parser = Parsers::Attack.new(text)

        result = parser.title

        expect(result).to eq('bite')
      end

      context 'when the weapon has an masterwork bonus' do
        it 'returns the text before the attack bonuses and after the count' do
          text = '+1 dagger +13/+8 (1d4+4/19–20)'
          parser = Parsers::Attack.new(text)

          result = parser.title

          expect(result).to eq('+1 dagger')
        end
      end

      context 'when the attack bonus is negative' do
        it 'returns the text before the attack bonuses and after the count' do
          text = 'slam –1 (1d3–4)'
          parser = Parsers::Attack.new(text)

          result = parser.title

          expect(result).to eq('slam')
        end
      end
    end

    describe '#bonuses' do
      context 'if there are many bonuses' do
        it 'returns an array of bonuses' do
          text = '+2 wounding spear +32/+27/+22/+17 (3d6+17/x3 plus 1 bleed)'
          parser = Parsers::Attack.new(text)

          result = parser.bonuses

          expect(result).to eq([32, 27, 22, 17])
        end
      end

      context 'if there is only one bonus' do
        it 'returns the single bonus in an array' do
          text = 'incorporeal touch +6 (1d6 negative energy plus 1d6 Con drain)'
          parser = Parsers::Attack.new(text)

          result = parser.bonuses

          expect(result).to eq([6])
        end
      end

      context 'when the bonus is negative' do
        it 'returns the single bonus in an array' do
          text = 'short sword –1 (1d3–3/19–20)'
          parser = Parsers::Attack.new(text)

          result = parser.bonuses

          expect(result).to eq([-1])
        end
      end
    end
  end
end
