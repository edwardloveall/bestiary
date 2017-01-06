module Bestiary
  RSpec.describe Parsers::Cmb do
    describe '.perform' do
      it 'returns an integer representing the combat maneuver bonus' do
        html = <<-HTML
        <p class="stat-block-1"><b>Base Atk</b> +33; <b>CMB</b> +57; <b>CMD</b> 73</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Cmb.perform(dom)

        expect(result).to eq(57)
      end

      context 'when CMB has conditional stats' do
        it 'returns only the base CMD' do
          html = <<-HTML
          <p class="stat-block-1"><b>Base Atk</b> +8; <b>CMB</b> +14 (+18 grapple); <b>CMD</b> 27 (31 vs. trip)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Cmb.perform(dom)

          expect(result).to eq(14)
        end
      end
    end
  end
end
