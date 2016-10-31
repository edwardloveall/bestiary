module Bestiary
  RSpec.describe Parsers::Space do
    describe '#parent_element' do
      it 'returns the containing element' do
        html = <<-HTML
        <p class="stat-block-1"><b>Ranged</b> improvised weapon +6 (1d3+2/×3)</p>
        <p class="stat-block-1"><b>Space</b> 2-1/2 ft.; <b>Reach</b> 0 ft.</p>
        <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th; concentration +8)</p>
        HTML
        dom = parse_html(html)
        parser = Parsers::Space.new(dom)
        parent = dom.css('p')[1]

        result = parser.parent_element

        expect(result).to eq(parent)
      end

      context 'when no speed or reach exists' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>Ranged</b> improvised weapon +6 (1d3+2/×3)</p>
          <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th; concentration +8)</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::Space.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end
  end
end
