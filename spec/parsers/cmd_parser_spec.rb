module Bestiary
  RSpec.describe Parsers::Cmd do
    describe '.perform' do
      it 'returns an integer representing the combat maneuver defense' do
        html = <<-HTML
        <p class="stat-block-1"><b>Base Atk</b> +33; <b>CMB</b> +57; <b>CMD</b> 73</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Cmd.perform(dom)

        expect(result).to eq(73)
      end

      context 'when CMD has conditional stats' do
        it 'returns only the base CMD' do
          html = <<-HTML
          <p class="stat-block-1"><b>Base Atk</b> +8; <b>CMB</b> +14 (+18 grapple); <b>CMD</b> 27 (31 vs. trip)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Cmd.perform(dom)

          expect(result).to eq(27)
        end
      end

      context 'when CMD is negative' do
        it 'returns only the base CMD' do
          html = <<-HTML
          <p class="stat-block-1"><b>Base Atk</b> +0; <b>CMB</b> –1; <b>CMD</b> -1</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Cmd.perform(dom)

          expect(result).to eq(-1)
        end
      end
    end
  end
end
