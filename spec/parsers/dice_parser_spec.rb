module Bestiary
  RSpec.describe Parsers::Dice do
    describe '#perform' do
      it 'returns an array of dice objects' do
        string = 'hp 44 (3 HD; 2d8+1d10+3)'
        dice = [
          Bestiary::Models::Die.new(count: 2, sides: 8),
          Bestiary::Models::Die.new(count: 1, sides: 10, bonus: 3)
        ]

        result = Parsers::Dice.perform(string)

        expect(result).to eq(dice)
      end
    end

    describe '#die_strings' do
      context 'a die with bonus' do
        it 'returns an array of dice objects' do
          string = ' 2 claws +18 (2d8+6/19–20 plus fear and grab)'
          die_strings = ['2d8+6']
          parser = Parsers::Dice.new(string)

          result = parser.die_strings

          expect(result).to eq(die_strings)
        end
      end

      context 'a die without bonus' do
        it 'returns an array of dice objects' do
          string = ' 2 claws +18 (2d8/19–20 plus fear and grab)'
          die_strings = ['2d8']
          parser = Parsers::Dice.new(string)

          result = parser.die_strings

          expect(result).to eq(die_strings)
        end
      end

      context 'multiple dice and a bonus' do
        it 'returns an array of dice objects' do
          string = 'hp 44 (3 HD; 2d8+1d10+3)'
          die_strings = ['2d8', '1d10+3']
          parser = Parsers::Dice.new(string)

          result = parser.die_strings

          expect(result).to eq(die_strings)
        end
      end

      context 'multiple dice with no bonus' do
        it 'returns an array of dice objects' do
          string = 'hp 44 (3 HD; 2d8+1d10)'
          die_strings = ['2d8', '1d10']
          parser = Parsers::Dice.new(string)

          result = parser.die_strings

          expect(result).to eq(die_strings)
        end
      end

      context 'no dice' do
        it 'returns and empty array' do
          string = 'numbers attempting to trip up the parser: 1 +11'
          parser = Parsers::Dice.new(string)

          result = parser.die_strings

          expect(result).to eq([])
        end
      end
    end
  end
end
