module Bestiary
  RSpec.describe Parsers::Regeneration do
    describe '.perform' do
      it 'returns a Regeneration attribute' do
        regen = Attributes::Regeneration.new(amount: 10,
                                             exceptions: ['cold iron'])

        result = Parsers::Regeneration.perform(common_document)

        expect(result).to eq(regen)
      end
    end

    describe '#parent_element' do
      it 'returns the element containing the regeneration information' do
        dom = common_document
        element = dom.at('p')
        parser = Parsers::Regeneration.new(dom)

        result = parser.parent_element

        expect(result).to eq(element)
      end

      context 'when there is no regeneration' do
        it 'returns nil' do
          html = '<p class="stat-block-1"><b>hp</b> 202 (15d12+105)</p>'
          dom = parse_html(html)
          parser = Parsers::Regeneration.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end

      context 'when regeneration is mentioned elsewhere' do
        it 'returns nil' do
          html = <<-HTML
          <p class="stat-block-1"><b>hp</b> 202 (15d12+105)</p>
          <p class="stat-block-1">This creature can be healed with regeneration</p>
          HTML
          dom = parse_html(html)
          parser = Parsers::Regeneration.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '#amount' do
      it 'returns an integer to use for the regeneration amount' do
        text = common_document.text
        parser = Parsers::Regeneration.new(nil)
        amount = 10

        result = parser.amount(text)

        expect(result).to eq(amount)
      end

      context 'when no amount is listed' do
        it 'returns nil' do
          text = 'hp 752 (35d10+560); regeneration (deific or mythic)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.amount(text)

          expect(result).to be_nil
        end
      end
    end

    describe '#exceptions' do
      it 'returns an array of exceptions' do
        text = common_document.text
        parser = Parsers::Regeneration.new(nil)

        result = parser.exceptions(text)

        expect(result).to eq(['cold iron'])
      end

      context 'when the exceptions are "or" separated' do
        it 'returns an array of exceptions' do
          text = 'hp 35 (10d6+5); regeneration 10 (bludgeoning or fire)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.exceptions(text)

          expect(result).to eq(%w(bludgeoning fire))
        end
      end

      context 'when the exceptions are "or" and an oxford comma separated' do
        it 'returns an array of exceptions' do
          text = 'hp 136 (13d10+65); regeneration 5 (acid, cold, or fire)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.exceptions(text)

          expect(result).to eq(%w(acid cold fire))
        end
      end

      context 'when the exceptions are separated by "and"' do
        it 'returns an array of exceptions' do
          text = 'hp 136 (13d10+65); regeneration 5 (acid and fire)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.exceptions(text)

          expect(result).to eq(%w(acid fire))
        end
      end

      context 'when the exceptions are "and" with an oxford comma separated' do
        it 'returns an array of exceptions' do
          text = 'hp 136 (13d10+65); regeneration 5 (acid, cold, and fire)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.exceptions(text)

          expect(result).to eq(%w(acid cold fire))
        end
      end

      context 'when the exceptions contain a "see X" instruction' do
        it 'returns an array of exceptions' do
          text = 'hp 422 (25d6+335); regeneration 30 (air; see airbane)'
          parser = Parsers::Regeneration.new(nil)

          result = parser.exceptions(text)

          expect(result).to eq(['air'])
        end
      end
    end

    def common_document
      html = <<-HTML
      <p class="stat-block-1"><b>hp</b> 202 (15d12+105); <a href="universalMonsterRules.html#regeneration">regeneration</a> 10 (cold iron)</p>
      HTML
      parse_html(html)
    end
  end
end
