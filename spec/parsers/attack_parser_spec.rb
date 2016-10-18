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

    describe '#damage' do
      it 'returns a die' do
        text = '+1 light mace +9/+4 (1d6+1)'
        parser = Parsers::Attack.new(text)
        damage = Models::Die.new(count: 1, sides: 6, bonus: 1)

        result = parser.damage

        expect(result).to eq(damage)
      end

      context 'when critical range and critical multiplier are present' do
        it 'returns a die' do
          text = '+2 scythe +25/+20/+15 (2d4+15/19–20/×4 plus poison)'
          parser = Parsers::Attack.new(text)
          damage = Models::Die.new(count: 2, sides: 4, bonus: 15)

          result = parser.damage

          expect(result).to eq(damage)
        end
      end

      context 'when no dice exist' do
        it 'returns nil' do
          text = 'tongue –1 touch (sticky tongue)'
          parser = Parsers::Attack.new(text)

          result = parser.damage

          expect(result).to be_nil
        end
      end

      context 'when the damage die has no bonus' do
        it 'returns a die' do
          text = 'shock +16 touch (2d8 electricity)'
          parser = Parsers::Attack.new(text)
          damage = Models::Die.new(count: 2, sides: 8, bonus: 0)

          result = parser.damage

          expect(result).to eq(damage)
        end
      end
    end

    describe '#critical_range' do
      it 'returns the size of the range of crit numbers' do
        text = 'mwk greatsword +18/+13 (3d6+12/19–20)'
        parser = Parsers::Attack.new(text)

        result = parser.critical_range

        expect(result).to eq(2)
      end

      context 'if no range exists' do
        it 'returns 1' do
          text = '2 claws +9 (1d6+4 plus grab)'
          parser = Parsers::Attack.new(text)

          result = parser.critical_range

          expect(result).to eq(1)
        end

        context 'but a critical multiplier does exist' do
          it 'returns 1' do
            text = 'longspear +12/+7 (1d8+7/x3)'
            parser = Parsers::Attack.new(text)

            result = parser.critical_range

            expect(result).to eq(1)
          end
        end
      end
    end
  end
end
