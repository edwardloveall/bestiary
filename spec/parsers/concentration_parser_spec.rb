module Bestiary
  RSpec.describe Parsers::Concentration do
    describe '.perform' do
      it 'returns an integer for concentration bonus' do
        html = <<-HTML
        <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th; concentration +9)</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Concentration.perform(dom)

        expect(result).to eq(9)
      end

      context 'when there are no spell-like abilities' do
        it 'returns nil' do
          html = '<p></p>'
          dom = parse_html(html)

          result = Parsers::Concentration.perform(dom)

          expect(result).to be_nil
        end
      end

      context 'when there is no concentration' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Concentration.perform(dom)

          expect(result).to be_nil
        end
      end

      context 'when there are specific spell-like abilities' do
        it 'returns an integer for concentration bonus' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Domain Spell-Like Abilities</strong> (CL 2nd; concentration +3)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Concentration.perform(dom)

          expect(result).to eq(3)
        end
      end

      context 'when the concentration bonus is negative' do
        it 'returns an integer for concentration bonus' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Domain Spell-Like Abilities</strong> (CL 2nd; concentration –3)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Concentration.perform(dom)

          expect(result).to eq(-3)
        end
      end
    end
  end
end
