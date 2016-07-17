module Bestiary
  RSpec.describe Parsers::Alignment do
    describe '#perform' do
      it 'returns one of the 9 valid alignments' do
        html = alignment_html('NG Small Vermin')
        dom = parse_html(html)

        result = Parsers::Alignment.perform(dom)

        expect(result).to eq('NG')
      end
    end

    def alignment_html(text)
      "<p class=\"stat-block-1\">#{text}</p>"
    end
  end
end
