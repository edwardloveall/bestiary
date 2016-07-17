module Bestiary
  RSpec.describe Parsers::Initiative do
    describe '.perform' do
      it 'returns a positive initiative number' do
        html = initiative_html(3)
        dom = parse_html(html)

        result = Parsers::Initiative.perform(dom)

        expect(result).to eq(3)
      end

      it 'returns a negative initiative number' do
        html = initiative_html(-3)
        dom = parse_html(html)

        result = Parsers::Initiative.perform(dom)

        expect(result).to eq(-3)
      end
    end

    def initiative_html(number)
      text = ''
      if number >= 0
        text = "+#{number}"
      else
        text = number
      end
      %(<p class="stat-block-1">
        <b>Init</b> #{number};
        <b>Senses</b> darkvision 120 ft.;
        <a href="/pathfinderRPG/prd/coreRulebook/skills/perception.html#perception">Perception</a> +2
      </p>)
    end
  end
end
