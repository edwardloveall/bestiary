module Bestiary
  RSpec.describe Parsers::Space do
    describe '.perform' do
      it 'returns the space in feet that the creature occupies' do
        html = <<-HTML
        <p class="stat-block-1"><b>Space</b> 2-1/2 ft.; <b>Reach</b> 0 ft.</p>
        HTML
        dom = parse_html(html)

        result = Parsers::Space.perform(dom)

        expect(result).to eq(2.5)
      end

      context 'if there is no space defined' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>Ranged</b> improvised weapon +6 (1d3+2/×3)</p>
          <p class="stat-block-1"><b>Spell-Like Abilities</b> (CL 6th; concentration +8)</p>
          HTML
          dom = parse_html(html)

          result = Parsers::Space.perform(dom)

          expect(result).to be_nil
        end
      end
    end

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

    describe '#feet' do
      it 'returns the space in feet that the creature occupies' do
        text = 'Space 15 ft.; Reach 10 ft.'
        parser = Parsers::Space.new(nil)

        result = parser.feet(text)

        expect(result).to eq(15)
      end

      context 'when there are half feet involved' do
        it 'returns a fractional number' do
          text = 'Space 2-1/2 ft.; Reach 0 ft.'
          parser = Parsers::Space.new(nil)

          result = parser.feet(text)

          expect(result).to eq(2.5)
        end
      end
    end
  end
end
