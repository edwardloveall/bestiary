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

          result = parser.parent_element

          expect(result).to eq(target_element)
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

          result = parser.parent_element

          expect(result).to eq(target_element)
        end
      end
    end

    describe '#senses_text' do
      it 'returns the text after "Senses"' do
        dom = parse_html %(<p class = "stat-block-1"><b>Init</b> +3; <b>Senses</b> darkvision 120 ft.; <a href = "/pathfinderRPG/prd/coreRulebook/skills/perception.html#perception">Perception</a> +8</p>)
        expected = ' darkvision 120 ft.; Perception +8'
        parser = Parsers::Senses.new(nil)

        result = parser.senses_text(dom)

        expect(result).to eq(expected)
      end
    end

    describe '#individual_senses' do
      it 'returns senses split by separators' do
        text = ' darkvision 120 ft.; Perception +8'
        parser = Parsers::Senses.new(nil)

        result = parser.individual_senses(text)

        expect(result).to eq([' darkvision 120 ft.', ' Perception +8'])
      end
    end

    describe '#sense_attributes' do
      it 'returns a hash of attributes' do
        sense_text = ' darkvision 120 ft.'
        parser = Parsers::Senses.new(nil)

        attributes = parser.sense_attributes(sense_text)

        expect(attributes).to eq(title: 'Darkvision',
                                 value: 120,
                                 unit: 'ft.')
      end
    end
  end
end
