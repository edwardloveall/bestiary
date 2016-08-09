module Bestiary
  RSpec.describe Parsers::Type do
    describe '.perform' do
      it 'returns the creature type' do
        html = <<-HTML
        <p class="stat-block-1">CE Large <a href="creatureTypes.html#humanoid" >humanoid</a></p>
        HTML
        dom = parse_html(html)
        humanoid = Attributes::Type.new(title: 'humanoid')

        result = Parsers::Type.perform(dom)

        expect(result).to eq(humanoid)
      end

      it 'returns the creature subtypes' do
        html = <<-HTML
        <p class="stat-block-1">LE Large outsider (devil, evil, extraplanar, lawful)</p>
        HTML
        subtypes = %w(devil evil extraplanar lawful)
        dom = parse_html(html)
        outsider = Attributes::Type.new(title: 'outsider',
                                        subtypes: subtypes)

        result = Parsers::Type.perform(dom)

        expect(result).to eq(outsider)
      end
    end

    describe '#parent_element' do
      it 'returns the parent element of the type' do
        html = <<-HTML
        <p class="stat-block-1">CE Large <a href="creatureTypes.html#humanoid" >humanoid</a> (giant)</p>
        HTML
        dom = parse_html(html)
        stat = dom.at('p')
        parser = Parsers::Type.new(dom)

        parent = parser.parent_element

        expect(parent).to eq(stat)
      end
    end
  end
end
