module Bestiary
  RSpec.describe Parsers::Armor do
    describe '.perform' do
      it 'returns an array of Armor attributes' do
        html = <<-HTML
        <p class="stat-block-1"><b>AC</b> 19, touch 10, flat-footed 19 (+9 natural; +2 deflection vs. evil)</p>
        HTML
        dom = parse_html(html)
        armors = [
          Attributes::Armor.new(title: 'ac', bonus: 19),
          Attributes::Armor.new(title: 'touch', bonus: 10),
          Attributes::Armor.new(title: 'flat-footed', bonus: 19),
          Attributes::Armor.new(title: 'natural', bonus: 9),
          Attributes::Armor.new(title: 'deflection vs. evil', bonus: 2)
        ]

        result = Parsers::Armor.perform(dom)

        expect(result).to match_array(armors)
      end
    end

    describe '#parent_element' do
      it 'returns the element containing all armor text' do
        html = <<-HTML
        <p class="stat-block-1"><b>AC</b> 21, touch 17, flat-footed 13 (+7 Dex, +1 dodge, +4 natural, –1 size)</p>
        HTML
        dom = parse_html(html)
        stat = dom.at('p')
        parser = Parsers::Armor.new(dom)

        parent = parser.parent_element

        expect(parent).to eq(stat)
      end
    end

    describe '#armor_pairs' do
      it 'splits the text of the armor into pairs by title and value' do
        html = <<-HTML
				<p class="stat-block-1"><b>AC</b> 19, touch 10, flat-footed 19 (+9 natural; +2 deflection vs. evil)</p>
        HTML
        dom = parse_html(html)
        parser = Parsers::Armor.new(dom)
        pairs = ['ac 19',
                 'touch 10',
                 'flat-footed 19',
                 '+9 natural',
                 '+2 deflection vs. evil']

        result = parser.armor_pairs

        expect(result).to eq(pairs)
      end
    end
  end
end
