module Bestiary
  RSpec.describe Parsers::AbilityScores do
    describe '.perform' do
      it 'returns a hash of all ability scores' do
        html = <<-HTML
        <p class="stat-block-1"><b>Str</b> 18, <b>Dex</b> 13, <b>Con</b> 12, <b>Int</b> 10, <b>Wis</b> 16, <b>Cha</b> 8</p>
        HTML
        dom = parse_html(html)
        ability_scores = { str: 18, dex: 13, con: 12, int: 10, wis: 16, cha: 8 }

        result = Parsers::AbilityScores.perform(dom)

        expect(result).to eq(ability_scores)
      end
    end

    describe '#parent_text' do
      it 'returns all the text for all abilities' do
        html = <<-HTML
        <p class="stat-block-1"><b>Str</b> 18, <b>Dex</b> 12, <b>Con</b> 14,</p>
        <p class="stat-block-1"><b>Int</b> 10, <b>Wis</b> 16, <b>Cha</b> 8</p>
        HTML
        dom = parse_html(html)
        parser = Parsers::AbilityScores.new(dom)

        result = parser.parent_text

        expect(result).to include('Str')
        expect(result).to include('Dex')
        expect(result).to include('Con')
        expect(result).to include('Int')
        expect(result).to include('Wis')
        expect(result).to include('Cha')
      end
    end

    describe '#sanitize' do
      it 'removes the space after commas' do
        text = 'Str 10, Wis 14'
        parser = Parsers::AbilityScores.new(nil)

        result = parser.sanitize(text)

        expect(result).to eq('Str 10,Wis 14')
      end

      it 'removes soft hyphens' do
        text = 'Str ­–'
        parser = Parsers::AbilityScores.new(nil)

        result = parser.sanitize(text)

        expect(result).to eq('Str –')
      end
    end

    describe '#abilities' do
      it 'returns a hash of all ability scores' do
        text = 'Str 18, Dex 13, Con 12, Int 10, Wis 16, Cha 8'
        ability_scores = { str: 18, dex: 13, con: 12, int: 10, wis: 16, cha: 8 }
        parser = Parsers::AbilityScores.new(nil)

        result = parser.abilities(text)

        expect(result).to eq(ability_scores)
      end

      context 'when an ability is not applicable' do
        it 'converts that ability into nil' do
          text = 'Str —, Dex 13, Con 12, Int 10, Wis 16, Cha 8'
          ability_scores = {
            str: nil, dex: 13, con: 12, int: 10, wis: 16, cha: 8
          }
          parser = Parsers::AbilityScores.new(nil)

          result = parser.abilities(text)

          expect(result).to eq(ability_scores)
        end
      end
    end

    describe '#score' do
      it 'returns an integer when passed an integer string' do
        text = '1'
        parser = Parsers::AbilityScores.new(nil)

        result = parser.score(text)

        expect(result).to eq(1)
      end

      context 'when the score is blank' do
        it 'returns nil' do
          text = '—'
          parser = Parsers::AbilityScores.new(nil)

          result = parser.score(text)

          expect(result).to be_nil
        end
      end
    end
  end
end
