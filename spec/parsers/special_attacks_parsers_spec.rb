module Bestiary
  RSpec.describe Parsers::SpecialAttacks do
    describe '#perform' do
      it 'calls parse_attacks with the text' do
        html = <<-HTML
        <p class="stat-block-1"><b>Special Attacks</b> <a href="universalMonsterRules.html#gaze">gaze</a></p>
        HTML
        dom = parse_html(html)
        parser = Parsers::SpecialAttacks.new(dom)
        text = 'Special Attacks gaze'
        allow(parser).to receive(:parse_attacks).with(text)

        parser.perform

        expect(parser).to have_received(:parse_attacks).with(text)
      end
    end

    describe '#parse_attacks' do
      it 'returns an array of special attacks' do
        text = 'Special Attacks gaze'
        parser = Parsers::SpecialAttacks.new(nil)
        attacks = ['gaze']

        result = parser.parse_attacks(text)

        expect(result).to eq(attacks)
      end

      context 'when an attack has a space in the name' do
        it 'returns an array of special attacks' do
          text = 'Special Attacks spit acid'
          parser = Parsers::SpecialAttacks.new(nil)
          attacks = ['spit acid']

          result = parser.parse_attacks(text)

          expect(result).to eq(attacks)
        end
      end

      context 'when an attack has a extra info in parenthesis' do
        it 'returns an array of special attacks' do
          text = 'Special Attacks rage (12 rounds/day), rage powers (no escape, superstition +3)'
          parser = Parsers::SpecialAttacks.new(nil)
          attacks = ['rage', 'rage powers']

          result = parser.parse_attacks(text)

          expect(result).to eq(attacks)
        end
      end

      context 'when an attack starts with a non-word character' do
        it 'returns an array of special attacks' do
          text = 'Special Attacks +1 on attack rolls against goblinoid and orc humanoids'
          parser = Parsers::SpecialAttacks.new(nil)
          attacks = ['+1 on attack rolls against goblinoid and orc humanoids']

          result = parser.parse_attacks(text)

          expect(result).to eq(attacks)
        end
      end

      context 'when there are many, complicated special attacks' do
        it 'returns an array of special attacks' do
          text = 'Special Attacks breath weapon (60-ft. cone, 25d6 acid, Reflex DC 30 half, usable every 1d4 rounds), constrict (2d8+13), poison, swallow whole (10d6 bludgeoning damage, AC 25, 36 hp)'
          parser = Parsers::SpecialAttacks.new(nil)
          attacks = ['breath weapon', 'constrict', 'poison', 'swallow whole']

          result = parser.parse_attacks(text)

          expect(result).to eq(attacks)
        end
      end
    end
  end
end
