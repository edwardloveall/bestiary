module Bestiary
  RSpec.describe Parsers::Size do
    describe '.perform' do
      it 'returns a size if creature contains a valid size' do
        html = <<-HTML
				<p class="stat-block-1">CE Large <a href="creatureTypes.html#humanoid" >humanoid</a> (giant)</p>
        HTML
        dom = parse_html(html)

        size = Parsers::Size.perform(dom)

        expect(size).to eq('Large')
      end
    end
  end
end
