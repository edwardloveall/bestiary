module Bestiary
  RSpec.describe Parsers::Resistances do
    describe '#parent_element' do
      it 'returns the containing element' do
        html = <<-HTML
        <p class="stat-block-1"><b>DR</b> 5/cold iron or <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#good-subtype">good</a>; <b>Immune</b> <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a>, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#poison-(ex-or-su)">poison</a>; <b>Resist</b> acid 10, electricity 10; <b>SR</b> 15</p>
        HTML
        dom = parse_html(html)
        parser = Parsers::Resistances.new(dom)
        parent = dom.at('p')

        result = parser.parent_element

        expect(result).to eq(parent)
      end

      context 'if no resistance is present' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>DR</b> 5/cold iron or <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#good-subtype">good</a>; <b>Immune</b> <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a>, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#poison-(ex-or-su)">poison</a>; <b>SR</b> 15</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::Resistances.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '.perform' do
      context 'when parent_element returns nil' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>DR</b> 5/cold iron or <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#good-subtype">good</a>; <b>Immune</b> <a href="/pathfinderRPG/prd/bestiary/creatureTypes.html#fire-subtype">fire</a>, <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#poison-(ex-or-su)">poison</a>; <b>SR</b> 15</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Resistances.perform(dom)

          expect(result).to be_nil
        end
      end

      it 'returns array of Resistance attributes' do
        html = <<-HTML
        <p class="stat-block-1"><b>Resist </b>acid 5, cold 5, electricity 5</p>
        HTML
        dom = parse_html(html)
        resistances = [
          Attributes::Resistance.new(title: 'acid', bonus: 5),
          Attributes::Resistance.new(title: 'cold', bonus: 5),
          Attributes::Resistance.new(title: 'electricity', bonus: 5)
        ]

        result = Parsers::Resistances.perform(dom)

        expect(result).to eq(resistances)
      end
    end

    context 'when resistances are separated by "and"' do
      it 'returns array of Resistance attributes' do
        html = <<-HTML
        <p class="stat-block-1"><b>Immune</b> electricity, <a href="universalMonsterRules.html#plant-traits">plant traits</a>; <b>Resist</b> cold 10 and fire 10</p>
        HTML
        dom = parse_html(html)
        resistances = [
          Attributes::Resistance.new(title: 'cold', bonus: 10),
          Attributes::Resistance.new(title: 'fire', bonus: 10)
        ]

        result = Parsers::Resistances.perform(dom)

        expect(result).to eq(resistances)
      end
    end

    context 'when resistance has no bonus' do
      it 'returns nil' do
        html = <<-HTML
        <p class="stat-block-1"><b>Defensive Abilities </b><a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#negative-energy-affinity">negative energy affinity</a>, resist level drain</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Resistances.perform(dom)

        expect(result).to be_nil
      end
    end
  end
end
