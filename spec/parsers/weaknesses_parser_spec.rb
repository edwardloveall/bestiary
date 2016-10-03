module Bestiary
  RSpec.describe Parsers::Weaknesses do
    describe '.perform' do
      it 'returns an array of weaknesses for the creature' do
        html = '<p class="stat-block-1"><b>Weakness </b>light sensitivity</p>'
        dom = parse_html(html)
        weakness = ['light sensitivity']

        result = Parsers::Weaknesses.perform(dom)

        expect(result).to eq(weakness)
      end

      context 'when weakness is inserted after spell resistance' do
        it 'returns an array of weaknesses for the creature' do
          html = <<-HTML
          <p class="stat-block-1"><strong>DR</strong> 15/cold iron and epic; <strong>Immune</strong> daze, mind-affecting effects, stagger, stun; <strong>Resist</strong> acid 30, cold 30, electricity 30, fire 30, sonic 30; <strong>SR</strong> 32; <strong>Weakness</strong> airbane</p>
          HTML
          dom = parse_html(html)
          weakness = ['airbane']

          result = Parsers::Weaknesses.perform(dom)

          expect(result).to eq(weakness)
        end
      end

      context 'when it is labeled weaknesses' do
        it 'returns an array of weaknesses for the creature' do
          html = <<-HTML
          <p class="stat-block-1"><b>Weaknesses</b> <a href="universalMonsterRules.html#light-blindness">light blindness</a></p>
          HTML
          dom = parse_html(html)
          weakness = ['light blindness']

          result = Parsers::Weaknesses.perform(dom)

          expect(result).to eq(weakness)
        end
      end

      context 'when there are multiple weaknesses' do
        it 'returns an array of weaknesses for the creature' do
          html = <<-HTML
          <p class="stat-block-1"><b>Weaknesses</b> resurrection vulnerability, sunlight powerlessness</p>
          HTML
          dom = parse_html(html)
          weakness = ['resurrection vulnerability', 'sunlight powerlessness']

          result = Parsers::Weaknesses.perform(dom)

          expect(result).to eq(weakness)
        end
      end

      context 'when "weaknesses" is in the name' do
        it 'returns an array of weaknesses for the creature' do
          html = <<-HTML
          <p class="stat-block-1"><b>Weaknesses</b> vampire weaknesses</p>
          HTML
          dom = parse_html(html)
          weakness = ['vampire weaknesses']

          result = Parsers::Weaknesses.perform(dom)

          expect(result).to eq(weakness)
        end
      end
    end
  end
end
