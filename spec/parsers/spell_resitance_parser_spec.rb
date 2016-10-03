module Bestiary
  RSpec.describe Parsers::SpellResistance do
    describe 'perform' do
      it 'returns the spell resistance for a creature' do
        html = '<p class="stat-block-1"><b>Immune </b>sleep; <b>SR</b> 7</p>'
        dom = parse_html(html)
        sr = 7

        result = Parsers::SpellResistance.perform(dom)

        expect(result).to eq(sr)
      end

      context 'when text comes after SR' do
        it 'returns the spell resistance' do
          html = <<-HTML
          <p class="stat-block-1"><b>Defensive Abilities</b> displacement, evasion, freedom of movement; <b>DR</b> 15/cold iron and <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#lawful-subtype">lawful</a>; <b>Immune</b> acid, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#cold-subtype">cold</a>, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#poison-(ex-or-su)">poison</a>, mind-affecting effects; <b>Resist</b> electricity 10, <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a> 10; <b>SR</b> 25 vs. <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#lawful-subtype">lawful</a> spells and creatures</p>
          HTML
          dom = parse_html(html)
          sr = 25

          result = Parsers::SpellResistance.perform(dom)

          expect(result).to eq(sr)
        end
      end
    end
  end
end
