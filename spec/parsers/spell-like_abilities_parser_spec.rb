module Bestiary
  RSpec.describe Parsers::SpellLikeAbilities do
    describe '#perform' do
      it 'calls the other methods' do
        parser = Parsers::SpellLikeAbilities.new(nil)
        allow(parser).to receive(:parent_element).and_return('')
        allow(parser).to receive(:ability_text)
        allow(parser).to receive(:abilities)

        parser.perform

        expect(parser).to have_received(:ability_text)
        expect(parser).to have_received(:abilities)
      end
    end

    describe '#ability_text' do
      context 'when there is only one set of spell-like abilities' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><b>Domain Spell-Like Abilities</b> (CL 6th; concentration +9)</p>
          <p class="stat-block-2">6/day—dazing touch, touch of chaos</p>
          HTML
          dom = parse_html(html)
          text = ['6/day—dazing touch, touch of chaos']
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end

      context 'when there are spells prepared afterward' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><b>Domain Spell-Like Abilities</b> (CL 6th; concentration +9)</p>
          <p class="stat-block-2">6/day—dazing touch, touch of chaos</p>
          <p class="stat-block-1"><b>Cleric Spells Prepared</b> (CL 6th; concentration +9)</p>
          HTML
          dom = parse_html(html)
          text = ['6/day—dazing touch, touch of chaos']
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end

      context 'when there are multiple sets of spell-like abilities' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><b>Gnome Spell-Like Abilities </b>(CL 2nd; concentration +3)<b></b></p>
          <p class="stat-block-2">1/day—<i><a href="/pathfinderRPG/prd/coreRulebook/spells/dancingLights.html#dancing-lights">dancing lights</a></i>, <i><a href="/pathfinderRPG/prd/coreRulebook/spells/ghostSound.html#ghost-sound">ghost sound</a></i>, <i><a href="/pathfinderRPG/prd/coreRulebook/spells/prestidigitation.html#prestidigitation">prestidigitation</a></i>, <i><a href="/pathfinderRPG/prd/coreRulebook/spells/speakWithAnimals.html#speak-with-animals">speak with animals</a></i></p>
          <p class="stat-block-1"><b>Arcane School Spell-Like Abilities</b> (CL 2nd; concentration +4)</p>
          <p class="stat-block-2">5/day—dazing touch</p>
          HTML
          dom = parse_html(html)
          text = [
            '1/day—dancing lights, ghost sound, prestidigitation, speak with animals',
            '5/day—dazing touch'
          ]
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end

      context 'when there are at will spell-like abilities' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 14th)</p>
          <p class="stat-block-2">At will—<i><a href="/pathfinderRPG/prd/coreRulebook/spells/darkness.html#darkness">darkness</a></i> (60-ft. radius)</p>
          HTML
          dom = parse_html(html)
          text = ['At will—darkness (60-ft. radius)']
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end

      context 'when there are constant spell-like abilities' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 10th; concentration +15)</p>
          <p class="stat-block-2">Constant—<i><a href="/pathfinderRPG/prd/coreRulebook/spells/tongues.html#tongues">tongues</a></i></p>
          <p class="stat-block-2">3/day—<i><a href="/pathfinderRPG/prd/coreRulebook/spells/detectThoughts.html#detect-thoughts">detect thoughts</a></i> (DC 17), <i><a href="/pathfinderRPG/prd/coreRulebook/spells/hypnoticPattern.html#hypnotic-pattern">hypnotic pattern</a></i> (DC 17), <i><a href="/pathfinderRPG/prd/coreRulebook/spells/levitate.html#levitate">levitate</a></i>, <i><a href="/pathfinderRPG/prd/coreRulebook/spells/minorImage.html#minor-image">minor image</a></i> (DC 17)</p>
          <p class="stat-block-2">1/day—<i><a href="/pathfinderRPG/prd/coreRulebook/spells/locateObject.html#locate-object">locate object</a></i>, <i><a href="/pathfinderRPG/prd/coreRulebook/spells/planeShift.html#plane-shift">plane shift</a></i> (DC 20, self only)</p>
          HTML
          dom = parse_html(html)
          text = [
            'Constant—tongues',
            '3/day—detect thoughts (DC 17), hypnotic pattern (DC 17), levitate, minor image (DC 17)',
            '1/day—locate object, plane shift (DC 20, self only)'
          ]
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end

      context 'when there are periodic abilities that are not per day' do
        it 'returns all lines of text related to spell-like abilities' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Spell-Like Abilities</strong> (CL 18th; concentration +18)</p>
          <p class="stat-block-2">1/month—<em>earthquake</em></p>
          HTML
          dom = parse_html(html)
          text = ['1/month—earthquake']
          parser = Parsers::SpellLikeAbilities.new(dom)

          result = parser.ability_text

          expect(result).to eq(text)
        end
      end
    end

    describe '#abilities' do
      it 'returns an array of abilities' do
        text = ['At will—control water, call lightning (DC 20), create water, hydraulic push*, water walk']
        abilities = ['control water', 'call lightning', 'create water', 'hydraulic push', 'water walk']
        parser = Parsers::SpellLikeAbilities.new(nil)

        result = parser.abilities(text)

        expect(result).to eq(abilities)
      end

      context 'when there are multiple lines of abilities' do
        it 'returns an array of abilities' do
          text = [
            'At will—elemental wall (9 rounds/day)',
            '7/day—force missile (1d4+4)'
          ]
          abilities = ['elemental wall', 'force missile']
          parser = Parsers::SpellLikeAbilities.new(nil)

          result = parser.abilities(text)

          expect(result).to eq(abilities)
        end
      end

      context 'when ability parentheticals have a comma' do
        it 'returns an array of abilities' do
          text = ['1/day—locate object, plane shift (DC 20, self only)']
          abilities = ['locate object', 'plane shift']
          parser = Parsers::SpellLikeAbilities.new(nil)

          result = parser.abilities(text)

          expect(result).to eq(abilities)
        end
      end
    end
  end
end
