module Bestiary
  RSpec.describe Parsers::AttackBonus do
    describe '#perform' do
      it 'returns an integer for the base attack bonus' do
        html = <<-HTML
        <p class="stat-block-1"><b>Base Atk</b> +33; <b>CMB</b> +57; <b>CMD</b> 73</p>
        HTML
        dom = parse_html(html)

        result = Parsers::AttackBonus.perform(dom)

        expect(result).to eq(33)
      end
    end
  end
end
