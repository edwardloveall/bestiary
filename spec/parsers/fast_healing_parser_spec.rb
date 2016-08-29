module Bestiary
  RSpec.describe Parsers::FastHealing do
    describe '.perform' do
      it 'returns the amount healed per round' do
        parser = Parsers::FastHealing.new(common_document)

        result = parser.perform

        expect(result).to eq(10)
      end
    end

    describe '#parent_element' do
      context 'when fast healing exists' do
        it 'returns the element that encapsulates fast healing' do
          dom = common_document
          parser = Parsers::FastHealing.new(dom)
          parent = dom.at('p')

          result = parser.parent_element

          expect(result).to eq(parent)
        end
      end

      context 'when fast healing is absent' do
        it 'returns nil' do
          html = '<p class="stat-block-1"><b>hp</b> 333 (23d8+230);</p>'
          dom = parse_html(html)
          parser = Parsers::FastHealing.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end

      context 'when fast healing is elsewhere in the document' do
        it 'returns nil' do
          html = '<p class="stat-block-1"><b>hp</b> 333 (23d8+230);</p>'
          html += '<p>other creatures use fast healing to be awesome</p>'
          dom = parse_html(html)
          parser = Parsers::FastHealing.new(dom)

          result = parser.parent_element

          expect(result).to be_nil
        end
      end
    end

    describe '#amount' do
      it 'returns the amount healed per round' do
        text = 'hp 333 (23d8+230); fast healing 10'
        parser = Parsers::FastHealing.new(nil)

        result = parser.amount(text)

        expect(result).to eq(10)
      end

      context 'when there is a note attached' do
        it 'returns the amount healed per round' do
          text = 'hp 333 (23d8+230); fast healing 10 (see harvester of sorrow)'
          parser = Parsers::FastHealing.new(nil)

          result = parser.amount(text)

          expect(result).to eq(10)
        end
      end
    end

    def common_document
      html = <<-HTML
      <p class="stat-block-1"><b>hp</b> 333 (23d8+230); <a href="universalMonsterRules.html#fast-healing">fast healing</a> 10</p>
      HTML
      parse_html(html)
    end
  end
end
