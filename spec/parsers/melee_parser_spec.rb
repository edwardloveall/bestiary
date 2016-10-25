module Bestiary
  RSpec.describe Parsers::Melee do
    describe '#perform' do
      context 'with one attack' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> 5 tentacles +7 (1d4+2 plus grab)</p>
          HTML
          dom = parse_html(html)
          attacks = [tentacles]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'with two attacks' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> <i>+5 <a href="/pathfinderRPG/prd/coreRulebook/magicItems/weapons.html#weapons-holy">holy</a> cold iron club</i> +48/+43/+38/+33 (1d8+18/15–20), 5 tentacles +7 (1d4+2 plus grab)</p>
          HTML
          dom = parse_html(html)
          attacks = [club, tentacles]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when multiple attacks are separated by "or"' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> <i>+5 <a href="/pathfinderRPG/prd/coreRulebook/magicItems/weapons.html#weapons-holy">holy</a> cold iron club</i> +48/+43/+38/+33 (1d8+18/15–20) or 5 tentacles +7 (1d4+2 plus grab)</p>
          HTML
          dom = parse_html(html)
          attacks = [club, tentacles]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when multiple attacks are separated by "and"' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> <i>+5 <a href="/pathfinderRPG/prd/coreRulebook/magicItems/weapons.html#weapons-holy">holy</a> cold iron club</i> +48/+43/+38/+33 (1d8+18/15–20) and 5 tentacles +7 (1d4+2 plus grab)</p>
          HTML
          dom = parse_html(html)
          attacks = [club, tentacles]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when a single attack has the word "and"' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> bite +5 (2d6+4 plus 1d4 acid and grab)</p>
          HTML
          dom = parse_html(html)
          attacks = [bite]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when a attacks have a space at the end' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> bite +5 (2d6+4 plus 1d4 acid and grab) </p>
          HTML
          dom = parse_html(html)
          attacks = [bite]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when a attacks additional effects outside the parenthesis' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> 5 tentacles +7 (1d4+2) plus grab</p>
          HTML
          dom = parse_html(html)
          attacks = [tentacles]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end

      context 'when a attacks additional effects outside the parenthesis' do
        it 'returns an array of Attack attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> slime squirt +4 ranged touch</p>
          HTML
          dom = parse_html(html)
          attacks = [slime_squirt]

          result = Parsers::Melee.perform(dom)

          expect(result).to eq(attacks)
        end
      end
    end

    describe '#parent_text' do
      it 'returns the text' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> bite +5 (2d6+4 plus 1d4 acid and grab) </p>
        HTML
        dom = parse_html(html)
        text = 'Melee bite +5 (2d6+4 plus 1d4 acid and grab)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end

      context 'when the text is on multiple lines' do
        it 'returns the text as a single string' do
          html = <<-HTML
          <p class="stat-block-1"><b>Melee</b> 2 slams +19 (1d8+11), bite +19 (2d6+11 plus <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#poison-(ex-or-su)">poison</a>) or</p>
          <p class="stat-block-2">heavy mace +19/+14 (3d6+11), bite +17 (2d6+5 plus poison)</p>
          <p><b>Ranged</b> don't get this text</p>
          HTML
          dom = parse_html(html)
          text = 'Melee 2 slams +19 (1d8+11), bite +19 (2d6+11 plus poison) or heavy mace +19/+14 (3d6+11), bite +17 (2d6+5 plus poison)'
          parser = Parsers::Melee.new(dom)

          result = parser.parent_text

          expect(result).to eq(text)
        end
      end

      it 'stops on "Spell-Like Abilities"' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> <i>+2 disrupting warhammer</i> +26/+21/+16 (1d8+14/×3 plus stun) or slam +23 (1d8+12) </p>
        <p class="stat-block-1"><b><a href="universalMonsterRules.html#spell-like-abilities">Spell-Like Abilities</a> </b>(CL 13th)</p>
        HTML
        dom = parse_html(html)
        text = 'Melee +2 disrupting warhammer +26/+21/+16 (1d8+14/×3 plus stun) or slam +23 (1d8+12)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end

      it 'stops on "STATISTICS"' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> slam +5 (1d6+3)</p>
        <p class="stat-block-breaker">STATISTICS</p>
        HTML
        dom = parse_html(html)
        text = 'Melee slam +5 (1d6+3)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end

      it 'stops on Titlecase "Special Abilities"' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> slam +5 (1d6+3)</p>
        <p class="stat-block-breaker">Special Abilities</p>
        HTML
        dom = parse_html(html)
        text = 'Melee slam +5 (1d6+3)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end

      it 'stops on singular "Special Attack"' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> slam +5 (1d6+3)</p>
        <p class="stat-block-breaker">Special Abilities</p>
        HTML
        dom = parse_html(html)
        text = 'Melee slam +5 (1d6+3)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end

      it 'stops on "Devilbound Spell-Like Abilities"' do
        html = <<-HTML
        <p class="stat-block-1"><b>Melee</b> slam +5 (1d6+3)</p>
        <p class="stat-block-breaker">Special Abilities</p>
        HTML
        dom = parse_html(html)
        text = 'Melee slam +5 (1d6+3)'
        parser = Parsers::Melee.new(dom)

        result = parser.parent_text

        expect(result).to eq(text)
      end
    end

    def tentacles
      Attributes::Attack.new(
        count: 5,
        title: 'tentacles',
        bonuses: [7],
        damage: Models::Die.new(count: 1, sides: 4, bonus: 2),
        additional_effects: ['grab']
      )
    end

    def club
      Attributes::Attack.new(
        count: 4,
        title: '+5 holy cold iron club',
        bonuses: [48, 43, 38, 33],
        damage: Models::Die.new(count: 1, sides: 8, bonus: 18),
        critical_range: 6
      )
    end

    def bite
      Attributes::Attack.new(
        count: 1,
        title: 'bite',
        bonuses: [5],
        damage: Models::Die.new(count: 2, sides: 6, bonus: 4),
        additional_effects: ['1d4 acid', 'grab']
      )
    end

    def slime_squirt
      Attributes::Attack.new(
        count: 1,
        title: 'slime squirt',
        bonuses: [4],
        damage: nil,
        additional_effects: ['ranged touch']
      )
    end
  end
end
