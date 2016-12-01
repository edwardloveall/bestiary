module Bestiary
  RSpec.describe Parsers::SpellsPrepared do
    describe '#spell_text' do
      it 'combines all the dom elements into an array of text' do
        html = <<-HTML
        <p class="stat-block-1"><strong>Psychic Spells Known</strong> (CL 1st; concentration +4)</p>
        <p class="stat-block-2">1st (4/day)— <a href="/pathfinderRPG/prd/occultAdventures/spells/burstOfInsight.html#burst-of-insight"><em>burst of insight</em></a>, <a href="/pathfinderRPG/prd/advancedClassGuide/spells/sunderingShards.html"><em>sundering shards</em></a> (DC 14)</p>
        <p class="stat-block-2">0 (at will)—<em>daze</em> (DC 13), <em>detect magic, mage hand</em>, <a href="/pathfinderRPG/prd/coreRulebook/spells/openClose.html#open-close"><em>open/close</em></a></p>
        <p class="stat-block-breaker">Statistics</p>
        HTML
        dom = parse_html(html)
        parser = Parsers::SpellsPrepared.new(dom)
        lines = [
          '1st (4/day)— burst of insight, sundering shards (DC 14)',
          '0 (at will)—daze (DC 13), detect magic, mage hand, open/close'
        ]

        result = parser.spell_text

        expect(result).to eq(lines)
      end
    end

    describe '#spells' do
      it 'returns an array of all spells' do
        lines = [
          '1st (4/day)— burst of insight, sundering shards (DC 14)',
          '0 (at will)—daze (DC 13), detect magic, mage hand, open/close'
        ]
        parser = Parsers::SpellsPrepared.new(nil)
        spells = [
          'burst of insight', 'sundering shards', 'daze', 'detect magic',
          'mage hand', 'open/close'
        ]

        result = parser.spells(lines)

        expect(result).to eq(spells)
      end
    end

    describe '#remove_level_and_frequency' do
      it 'removes spell level and per day text' do
        text = '7th (5/day)—insanity (DC 24), repulsion (DC 24)'
        parser = Parsers::SpellsPrepared.new(nil)

        result = parser.remove_level_and_frequency(text)

        expect(result).to eq('insanity (DC 24), repulsion (DC 24)')
      end
    end

    describe '#remove_parentheticals' do
      it 'removes parentheticals like DC' do
        text = 'insanity (DC 24)'
        parser = Parsers::SpellsPrepared.new(nil)

        result = parser.remove_parentheticals(text)

        expect(result).to eq('insanity')
      end
    end

    describe '#ambiguous_spell?' do
      it 'returns true when spell is ambiguous' do
        text = '2 more'
        parser = Parsers::SpellsPrepared.new(nil)

        result = parser.ambiguous_spell?(text)

        expect(result).to be_truthy
      end

      it 'returns true when spell is not ambiguous' do
        text = 'insanity'
        parser = Parsers::SpellsPrepared.new(nil)

        result = parser.ambiguous_spell?(text)

        expect(result).to be_falsey
      end
    end

    describe '#remove_special_characters' do
      it 'removes non-spell text characters' do
        text = 'fleshy facade *'
        parser = Parsers::SpellsPrepared.new(nil)

        result = parser.remove_special_characters(text)

        expect(result).to eq('fleshy facade ')
      end

      context 'when the spell name has a slash' do
        it 'removes non-spell text characters' do
          text = 'open/close'
          parser = Parsers::SpellsPrepared.new(nil)

          result = parser.remove_special_characters(text)

          expect(result).to eq('open/close')
        end
      end
    end
  end
end
