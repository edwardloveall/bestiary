module Bestiary
  RSpec.describe Parsers::Reflex do
    describe 'perform' do
      it 'returns the Reflex value from the creature' do
        result = Parsers::Reflex.perform(common_document)

        expect(result).to eq(7)
      end

      it 'returns negative values also' do
        html = <<-HTML
        <p class="stat-block-1"><b>Fort</b> +6, <b>Ref</b> –7, <b>Will</b> +2</p>
        HTML
        dom = parse_html(html)
        result = Parsers::Reflex.perform(dom)

        expect(result).to eq(-7)
      end
    end

    def common_document
      html = '<p class="stat-block-1"><b>Fort</b> +6, <b>Ref</b> +7, <b>Will</b> +2</p>'
      parse_html(html)
    end
  end
end
