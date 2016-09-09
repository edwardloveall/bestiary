module Bestiary
  RSpec.describe Parsers::DefensiveAbilities do
    describe '#parent_element' do
      it 'returns the element containing all the defensive abilities' do
        dom = common_document
        parent = dom.at('p')
        parser = Parsers::DefensiveAbilities.new(dom)

        result = parser.parent_element

        expect(result).to eq(parent)
      end

      context 'when there are no defensive abilities' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Fort</strong> +3, <strong>Ref</strong> +0, <strong>Will</strong> +7</p>
          <p class="stat-block-breaker">Offense</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::DefensiveAbilities.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '#perform' do
      it 'returns an array of generic attributes' do
        bloodthirst = Attributes::Generic.new(title: 'bloodthirst')
        channel = Attributes::Generic.new(title: 'channel resistance', bonus: 2)

        result = Parsers::DefensiveAbilities.perform(common_document)

        expect(result).to eq([bloodthirst, channel])
      end

      context 'when defensive abilities have extra text' do
        it 'return an array of generic attributes without the extra text' do
          html = <<-HTML
          <p class="stat-block-1"><b>Defensive Abilities</b> hardness 5 (or more); <b>Immune</b> <a href="universalMonsterRules.html#construct-traits">construct traits</a></p>
          HTML
          dom = parse_html(html)
          hardness = Attributes::Generic.new(title: 'hardness', bonus: 5)

          result = Parsers::DefensiveAbilities.perform(dom)

          expect(result).to eq([hardness])
        end
      end

      context 'when stat groups are only separated by a comma' do
        it 'return an array of generic attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Defensive Abilities</b> swarm traits, <b>Immune</b> weapon damage</p>
          HTML
          dom = parse_html(html)
          swarm = Attributes::Generic.new(title: 'swarm traits')

          result = Parsers::DefensiveAbilities.perform(dom)

          expect(result).to eq([swarm])
        end
      end

      context 'when stat groups are only separated by a space' do
        it 'return an array of generic attributes' do
          html = <<-HTML
          <p class="stat-block-1"><b>Defensive Abilities</b> <i>spell turning</i> <b>DR</b> 20/epic and <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#lawful-subtype">lawful</a>; <b>Immune</b> aging, death effects, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#disease-(ex-or-su)">disease</a>, mind-affecting effects; <b>SR</b> 35</p>
          HTML
          dom = parse_html(html)
          turning = Attributes::Generic.new(title: 'spell turning')

          result = Parsers::DefensiveAbilities.perform(dom)

          expect(result).to eq([turning])
        end
      end

      context 'when defensive abilities have weird characters' do
        context 'such as asterisks' do
          it 'return an array of generic attributes without the weirdness' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> natural cunning*; <b>DR</b> 5/magic; <b>Immune</b> poison; <b>Resist</b> acid 10, cold 10, electricity 10, fire 10; <b>SR</b> 17</p>
            HTML
            dom = parse_html(html)
            cunning = Attributes::Generic.new(title: 'natural cunning')

            result = Parsers::DefensiveAbilities.perform(dom)

            expect(result).to eq([cunning])
          end
        end

        context 'such as parenthesis' do
          it 'return an array of generic attributes without the weirdness' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> ink cloud (30-foot-radius sphere)</p>
            HTML
            dom = parse_html(html)
            swarm = Attributes::Generic.new(title: 'ink cloud')

            result = Parsers::DefensiveAbilities.perform(dom)

            expect(result).to eq([swarm])
          end
        end

        context 'such as hyphens' do
          it 'return an array of generic attributes' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> self-resurrection; <b>DR</b> 15/evil; <b>Immune</b> fire <b>SR</b> 26</p>
            HTML
            dom = parse_html(html)
            resurrection = Attributes::Generic.new(title: 'self-resurrection')

            result = Parsers::DefensiveAbilities.perform(dom)

            expect(result).to eq([resurrection])
          end
        end

        context 'such as commas inside of parenthesis' do
          it 'return an array of generic attributes' do
            html = <<-HTML
            <p class="stat-block-1"><b>Defensive Abilities</b> reactive strike, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#split">split</a> (sonic or slashing, 32 hp); <b>DR</b> 10/–; Immune acid, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#ooze">ooze</a> traits; <b>Resist</b> electricity 30, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a> 30</p>
            HTML
            dom = parse_html(html)
            strike = Attributes::Generic.new(title: 'reactive strike')
            split = Attributes::Generic.new(title: 'split')

            result = Parsers::DefensiveAbilities.perform(dom)

            expect(result).to eq([strike, split])
          end
        end
      end
    end

    def common_document
      html = <<-HTML
      <p class="stat-block-1"><strong>Defensive Abilities</strong> bloodthirst, channel resistance +2; <strong>DR</strong> 5/slashing; <strong>Immune</strong> undead traits</p>
      HTML
      parse_html(html)
    end
  end
end
