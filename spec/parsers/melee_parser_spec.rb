module Bestiary
  RSpec.describe Parsers::Melee do
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
  end
end
