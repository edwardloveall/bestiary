module Bestiary
  RSpec.describe Parsers::CasterLevel do
    describe '.perform' do
      it 'returns an integer for caster level' do
        html = <<-HTML
        <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th; concentration +9)</p>
        HTML
        dom = parse_html(html)

        result = Parsers::CasterLevel.perform(dom)

        expect(result).to eq(6)
      end

      context 'when there are no spell-like abilities' do
        it 'returns nil' do
          html = '<p></p>'
          dom = parse_html(html)

          result = Parsers::CasterLevel.perform(dom)

          expect(result).to be_nil
        end
      end

      context 'when there are specific spell-like abilities' do
        it 'returns an integer for caster level' do
          html = <<-HTML
          <p class="stat-block-1"><strong>Domain Spell-Like Abilities</strong> (CL 2nd; concentration +3)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::CasterLevel.perform(dom)

          expect(result).to eq(2)
        end
      end
    end
  end
end
