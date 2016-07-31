module Bestiary
  RSpec.describe Parsers::Type do
    describe '.perform' do
      it 'returns the creature type' do
        html = <<-HTML
        <p class="stat-block-1">CE Large <a href="creatureTypes.html#humanoid" >humanoid</a> (giant)</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Type.perform(dom)

        expect(result).to eq('humanoid')
      end
    end
  end
end
