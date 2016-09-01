module Bestiary
  RSpec.describe Parsers::Will do
    describe 'perform' do
      it 'returns the Will value from the creature' do
        result = Parsers::Will.perform(common_document)

        expect(result).to eq(2)
      end

      it 'returns negative values also' do
        html = <<-HTML
        <p class="stat-block-1"><b>Fort</b> +6, <b>Ref</b> +7, <b>Will</b> –2</p>
        HTML
        dom = parse_html(html)
        result = Parsers::Will.perform(dom)

        expect(result).to eq(-2)
      end
    end

    def common_document
      html = '<p class="stat-block-1"><b>Fort</b> +6, <b>Ref</b> +7, <b>Will</b> +2</p>'
      parse_html(html)
    end
  end
end
