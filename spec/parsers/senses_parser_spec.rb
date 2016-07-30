module Bestiary
  RSpec.describe Parsers::Senses do
    describe '#parent_element' do
      context 'when the senses are marked with <strong>' do
        it 'returns the seses parent element' do
          html = <<-HTML
          <strong>red herring</strong>
          <p class = "stat-block-1"><strong>Init</strong> +3; <strong>Senses</strong> darkvision 120 ft.; <a href = "/pathfinderRPG/prd/coreRulebook/skills/perception.html#perception">Perception</a> +8</p>
          HTML
          dom = parse_html(html)
          target_element = dom.at('p')

          parser = Parsers::Senses.new(dom)

          expect(parser.parent_element).to eq(target_element)
        end
      end

      context 'when the senses are marked with <b>' do
        it 'returns the seses parent element' do
          html = <<-HTML
          <b>red herring</b>
          <p class = "stat-block-1"><b>Init</b> +3; <b>Senses</b> darkvision 120 ft.; <a href = "/pathfinderRPG/prd/coreRulebook/skills/perception.html#perception">Perception</a> +8</p>
          HTML
          dom = parse_html(html)
          target_element = dom.at('p')

          parser = Parsers::Senses.new(dom)

          expect(parser.parent_element).to eq(target_element)
        end
      end
    end
  end
end
