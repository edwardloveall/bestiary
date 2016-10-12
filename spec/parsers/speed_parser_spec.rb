module Bestiary
  RSpec.describe Parsers::Speed do
    describe '#title' do
      it 'returns the text before the number' do
        text = ' burrow 30 ft. '
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('burrow')
      end

      it 'returns "movement" if "Speed" is the text' do
        text = 'Speed 30 ft.'
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('movement')
      end

      it 'returns "movement" if no title is present' do
        text = '); 35 ft., '
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('movement')
      end

      it 'returns title with "Speed" removed' do
        text = 'Speed fly 60 ft. (perfect)'
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('fly')
      end

      it 'removes weird punctuation' do
        text = ', fly 30 ft. (clumsy'
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('fly')
      end

      it 'works when there is no space before feet' do
        text = ' (35 ft. in armor'
        parser = Parsers::Speed.new(nil)

        result = parser.title(text)

        expect(result).to eq('movement')
      end
    end

    describe '#feet' do
      it 'returns the feet' do
        text = 'Speed 30 ft.'
        parser = Parsers::Speed.new(nil)

        result = parser.feet(text)

        expect(result).to eq(30)
      end
    end

    describe '#divide' do
      it 'splits all speeds up into individual pieces of text' do
        text = 'Speed 30 ft., fly 30 ft. (clumsy) '
        text += '(20 ft., fly 20 ft. [clumsy] in armor)'
        parser = Parsers::Speed.new(nil)
        speeds = ['Speed 30 ft.',
                  ', fly 30 ft. (clumsy',
                  ') (20 ft.',
                  ', fly 20 ft. [clumsy] in armor']

        result = parser.divide(text)

        expect(result).to eq(speeds)
      end

      context 'when fly has more than just a maneuverability' do
        it 'splits all speeds up into individual pieces of text' do
          text = 'Speed 30 ft., fly 60 ft. (perfect; in fiery form only)'
          parser = Parsers::Speed.new(nil)
          speeds = ['Speed 30 ft.', ', fly 60 ft. (perfect']

          result = parser.divide(text)

          expect(result).to eq(speeds)
        end
      end

      context 'when other speeds have parentheticals' do
        it 'splits all speeds up into individual pieces of text' do
          text = 'Speed 20 ft., burrow (ice and snow only) 20 ft., swim 60 ft.'
          parser = Parsers::Speed.new(nil)
          speeds = ['Speed 20 ft.',
                    ', burrow (ice and snow only) 20 ft.',
                    ', swim 60 ft.']

          result = parser.divide(text)

          expect(result).to eq(speeds)
        end
      end

      context 'when armor is listed last' do
        it 'splits all speeds up into individual pieces of text' do
          text = 'Speed 50 ft., fly 150 ft. (good); '
          text += '35 ft., fly 100 ft. (good) in armor'
          parser = Parsers::Speed.new(nil)
          speeds = ['Speed 50 ft.',
                    ', fly 150 ft. (good',
                    '); 35 ft.',
                    ', fly 100 ft. (good) in armor']

          result = parser.divide(text)

          expect(result).to eq(speeds)
        end
      end

      context 'when other conditions are at play' do
        it 'splits all speeds up into individual pieces of text' do
          text = 'Speed 60 ft. (30 ft. without haste), '
          text += 'fly 90 ft. (good, 60 ft. without haste)'
          parser = Parsers::Speed.new(nil)
          speeds = ['Speed 60 ft.',
                    ' (30 ft. without haste',
                    '), fly 90 ft. (good',
                    ', 60 ft. without haste']

          result = parser.divide(text)

          expect(result).to eq(speeds)
        end
      end

      context 'when "ft" exist as a different part of the speed' do
        it 'splits all speeds up into individual pieces of text' do
          text = 'Speed 80 ft., fly 200 ft. (average), swift flight'
          parser = Parsers::Speed.new(nil)
          speeds = ['Speed 80 ft.', ', fly 200 ft. (average']

          result = parser.divide(text)

          expect(result).to eq(speeds)
        end
      end
    end
  end
end
