module Bestiary
  RSpec.describe Parsers::DamageReduction do
    describe 'parent_element' do
      it 'returns the parent element containing the DR' do
        html = <<-HTML
        <p class="stat-block-1"><b>Defensive Abilities</b> channel <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#resistance">resistance</a> +2; <b>DR</b> 15/good and silver; <b>Immune</b> acid, undead traits</p>
        HTML
        dom = parse_html(html)
        parent = dom.at('p')
        parser = Parsers::DamageReduction.new(dom)

        result = parser.parent_element

        expect(result).to eq(parent)
      end

      context 'when DR appears after the OFFENSE separator' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-breaker">Offense</p>
          <p>The familier has DR 5/cold iron</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::DamageReduction.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '#perform' do
      context 'if the parent element is nil' do
        it 'returns nil' do
          html = '<p class="stat-block-1"><b>Weaknesses</b> head bowl</p>'
          dom = parse_html(html)

          result = Parsers::DamageReduction.perform(dom)

          expect(result).to be_nil
        end
      end

      context 'when there is one exception' do
        it 'returns a DamageReduction attribute' do
          html = <<-HTML
          <p class="stat-block-1"><b>DR</b> 5/cold iron; <b>SR</b> 12</p>
          HTML
          dom = parse_html(html)
          dr = Attributes::DamageReduction.new(amount: 5,
                                               exceptions: ['cold iron'])

          result = Parsers::DamageReduction.perform(dom)

          expect(result).to eq(dr)
        end

        context 'and the exception contains "or"' do
          it 'returns a DamageReduction attribute NOT split by or' do
            html = <<-HTML
            <p class="stat-block-1"><b>DR</b> 15/<i><a href="/pathfinderRPG/prd/coreRulebookmagicItems/weapons.html#vorpal">vorpal</a></i>; <b>Immune</b> <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a>, paralysis, sleep; <b>Resist</b> acid 30, electricity 30, sonic 30; <b>SR</b> 31</p>
            HTML
            dom = parse_html(html)
            dr = Attributes::DamageReduction.new(amount: 15,
                                                 exceptions: ['vorpal'])

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end

        context 'separated from the next defensive ability by a comma' do
          it 'returns a DamageReduction without the other attributes' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> fortification (50%); <b>DR</b> 15/epic, <b>Immune</b> electricity; <b>Resist</b> acid 30, cold 30, fire 30; <b>SR</b> 34</p>
            HTML
            dom = parse_html(html)
            dr = Attributes::DamageReduction.new(amount: 15,
                                                 exceptions: ['epic'])

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end
      end

      context 'when there are multiple exceptions' do
        context 'separated by "and"' do
          it 'returns a DamageReduction attribute' do
            html = <<-HTML
            <p class="stat-block-1"><b>DR</b> 10/cold iron and <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#evil-subtype">evil</a>; <b>Immune</b> electricity, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a>; <b>Resist</b> acid 10, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#cold-subtype">cold</a> 10; <b>SR</b> 25</p>
            HTML
            dom = parse_html(html)
            exceptions = ['cold iron', 'evil']
            dr = Attributes::DamageReduction.new(amount: 10,
                                                 exceptions: exceptions)

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end

        context 'separated by "or"' do
          it 'returns a DamageReduction attribute' do
            html = <<-HTML
            <p class="stat-block-1"><b>DR</b> 5/good or silver; <b>Immune</b> <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#cold-subtype">cold</a></p>
            HTML
            dom = parse_html(html)
            dr = Attributes::DamageReduction.new(amount: 5,
                                                 exceptions: %w(good silver))

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end
      end

      context 'when there are no exceptions' do
        context 'represented by an em dash' do
          it 'returns a DamageReduction attribute' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> air mastery; <b>DR</b> 5/—; <b>Immune</b> <a href="creatureTypes.html#elemental-subtype">elemental traits</a></p>
            HTML
            dom = parse_html(html)
            dr = Attributes::DamageReduction.new(amount: 5, exceptions: [])

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end

        context 'represented by an en dash' do
          it 'returns a DamageReduction attribute' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> reactive strike, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#split">split</a> (sonic or slashing, 32 hp); <b>DR</b> 10/–; Immune acid, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#ooze">ooze</a> traits; <b>Resist</b> electricity 30, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a> 30</p>
            HTML
            dom = parse_html(html)
            dr = Attributes::DamageReduction.new(amount: 10, exceptions: [])

            result = Parsers::DamageReduction.perform(dom)

            expect(result).to eq(dr)
          end
        end
      end

      context 'when there are multiple DRs' do
        it 'returns only the first DR' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Defensive Abilities</strong> channel resistance +4, improved uncanny dodge, orc ferocity, trap sense +3; <strong>DR</strong> 10/magic and silver and DR 1/—; <strong>Immune</strong> undead traits; <strong>Resist</strong> cold 10, electricity 10</p>
          HTML
          dom = parse_html(html)
          dr = Attributes::DamageReduction.new(amount: 10,
                                               exceptions: %w(magic silver))

          result = Parsers::DamageReduction.perform(dom)

          expect(result).to eq(dr)
        end
      end

      context 'when there is extra text' do
        it 'returns the non-extra text' do
          html = <<-HTML
          <p class="stat-block-1"><b>Defensive Abilities</b> defensive roll, defensive training (+4 dodge bonus to AC vs. giants), evasion, greater invisibility, improved uncanny dodge, slippery mind; <b>DR</b> 10/adamantine (100 points)</p>
          HTML
          dom = parse_html(html)
          dr = Attributes::DamageReduction.new(amount: 10,
                                               exceptions: ['adamantine'])

          result = Parsers::DamageReduction.perform(dom)

          expect(result).to eq(dr)
        end
      end
    end
  end
end
