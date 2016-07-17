module Bestiary
  RSpec.describe Parsers::Cr do
    describe 'perform' do
      it 'returns the CR value from the creature' do
        html = cr_html('1/2')
        dom = parse_html(html)

        result = Parsers::Cr.perform(dom)

        expect(result).to eq('1/2')
      end
    end

    def cr_html(text)
      %(<p class="stat-block-title">Giant Flea <span class="stat-block-cr">
      CR #{text}</span></p>)
    end
  end
end
