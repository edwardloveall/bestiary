module Bestiary
  RSpec.describe Parsers::Alignment do
    describe '#perform' do
      it 'returns one of the 9 valid alignments' do
        html = alignment_html('NG Small Vermin')
        dom = parse_html(html)

        result = Parsers::Alignment.perform(dom)

        expect(result).to eq('NG')
      end

      it 'returns not found if it cant find the alignment' do
        html = alignment_html('Foo Small Vermin')
        dom = parse_html(html)

        result = Parsers::Alignment.perform(dom)

        expect(result).to eq('not found')
      end
    end

    def alignment_html(text)
      "<p class=\"stat-block-1\">#{text}</p>"
    end
  end
end
