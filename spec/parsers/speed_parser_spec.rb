module Bestiary
  RSpec.describe Parsers::Speed do
    describe '.perform' do
      it 'returns an array of speed attributes' do
        html = '<p class="stat-block-1"><b>Speed</b> 30 ft., burrow 20 ft.</p>'
        dom = parse_html(html)

        results = Parsers::Speed.perform(dom)

        expect(results).not_to be_empty
        expect(results).to all(be_an(Attributes::Speed))
      end

      it 'returns speed attributes with proper data' do
        html = '<p class="stat-block-1"><b>Speed</b> 30 ft., burrow 20 ft.</p>'
        dom = parse_html(html)
        movement = Attributes::Speed.new(title: 'movement', feet: 30)
        burrow = Attributes::Speed.new(title: 'burrow', feet: 20)

        results = Parsers::Speed.perform(dom)

        expect(results).to eq([movement, burrow])
      end

      context 'with a fly speed' do
        it 'returns an speed attributes with proper data' do
          html = '<p class="stat-block-1"><b>Speed</b> fly 60 ft. (perfect)</p>'
          dom = parse_html(html)
          fly = Attributes::Speed.new(title: 'fly',
                                      feet: 60,
                                      maneuverability: :perfect)

          results = Parsers::Speed.perform(dom)

          expect(results).to eq([fly])
        end
      end
    end

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

    describe '#maneuverability' do
      context 'when maneuverability exists' do
        it 'returns the maneuverability' do
          text = ', fly 30 ft. (clumsy'
          parser = Parsers::Speed.new(nil)

          result = parser.maneuverability(text)

          expect(result).to eq(:clumsy)
        end
      end

      context 'when maneuverability does not exist' do
        it 'returns nil' do
          text = 'Speed 30 ft.'
          parser = Parsers::Speed.new(nil)

          result = parser.maneuverability(text)

          expect(result).to be_nil
        end
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

    describe '#armor_indexes' do
      context 'if no armor exists' do
        it 'returns an array of false values for each speed' do
          speeds = ['Speed 50 ft.', ' , fly 150 ft. (good)']
          indexes = [false, false]
          parser = Parsers::Speed.new(nil)

          result = parser.armor_indexes(speeds)

          expect(result).to eq(indexes)
        end
      end

      context 'armor is at the end' do
        it 'returns an array of false and true values' do
          speeds = [
            'Speed 50 ft.',
            ' , fly 150 ft. (good',
            ' ); 35 ft.',
            ' , fly 100 ft. (good) in armor'
          ]
          indexes = [false, false, true, true]
          parser = Parsers::Speed.new(nil)

          result = parser.armor_indexes(speeds)

          expect(result).to eq(indexes)
        end
      end

      context 'there is a speed after armor is specified' do
        it 'returns an array of false and true values' do
          speeds = ['Speed 40 ft.', '  (30 ft. in armor', ' ), climb 15 ft.']
          indexes = [false, true, false]
          parser = Parsers::Speed.new(nil)

          result = parser.armor_indexes(speeds)

          expect(result).to eq(indexes)
        end
      end
    end
  end
end
