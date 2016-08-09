module Bestiary
  RSpec.describe Parsers::Type do
    describe '.perform' do
      it 'returns the creature type' do
        html = <<-HTML
        <p class="stat-block-1">CE Large <a href="creatureTypes.html#humanoid" >humanoid</a> (giant)</p>
        HTML
        dom = parse_html(html)
        humanoid = Attributes::Type.new(title: 'humanoid')

        result = Parsers::Type.perform(dom)

        expect(result).to eq(humanoid)
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
