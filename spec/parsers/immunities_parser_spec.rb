module Bestiary
  RSpec.describe Parsers::Immunities do
    describe '#parent_element' do
      it 'returns the parent element containing the immunities' do
        html = <<-HTML
        <p class="stat-block-1"><b>Defensive Abilities</b> channel <a href="/pathfinderRPG/prd/bestiary/universalMonsterRules.html#resistance">resistance</a> +2; <b>DR</b> 15/good and silver; <b>Immune</b> acid, undead traits</p>
        HTML
        dom = parse_html(html)
        parent = dom.at('p')
        parser = Parsers::Immunities.new(dom)

        result = parser.parent_element

        expect(result).to eq(parent)
      end

      context 'when immunities appear after the OFFENSE separator' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-breaker">Offense</p>
          <p>The familier is Immune to cold iron</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::Immunities.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '.perform' do
      context 'if the parent element is nil' do
        it 'returns nil' do
          html = '<p class="stat-block-1"><b>Weaknesses</b> head bowl</p>'
          dom = parse_html(html)

          result = Parsers::Immunities.perform(dom)

          expect(result).to be_nil
        end
      end

      it 'returns an array of immunities' do
        html = <<-HTML
        <p class="stat-block-1"><strong>Defensive Abilities</strong> psychic resilience; <strong>Immune</strong> paralysis, sleep; <strong>SR</strong> 20</p>
        HTML
        dom = parse_html(html)
        immunities = %w(paralysis sleep)

        result = Parsers::Immunities.perform(dom)

        expect(result).to eq(immunities)
      end
    end
  end
end
