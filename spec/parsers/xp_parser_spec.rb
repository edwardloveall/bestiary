module Bestiary
  RSpec.describe Parsers::Xp do
    describe '.perform' do
      it 'returns the XP as an integer' do
        html = '<p class="stat-block-xp">XP 4,800</p>'
        dom = parse_html(html)

        xp = Parsers::Xp.perform(dom)

        expect(xp).to eq(4800)
      end
    end
  end
end
