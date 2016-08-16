module Bestiary
  RSpec.describe Parsers::Hp do
    describe '.perform' do
      it 'returns a value and dice' do
        html = '<p class="stat-block-1"><b>hp</b> 103 (9d10+54)</p>'
        dom = parse_html(html)
        dice = [Models::Die.new(count: 9, sides: 10, bonus: 54)]
        hp = Attributes::Hp.new(value: 103, dice: dice)

        result = Parsers::Hp.perform(dom)

        expect(result).to eq(hp)
      end
    end

    describe '#value' do
      it 'returns the combined hp value for a creature' do
        html = '<p class="stat-block-1"><b>hp</b> 103 (9d10+54)</p>'
        dom = parse_html(html)
        value = 103
        parser = Parsers::Hp.new(dom)

        result = parser.value

        expect(result).to eq(value)
      end
    end

    describe '#dice' do
      it 'returns the dice array for the hp of a creature' do
        html = '<p class="stat-block-1"><b>hp</b> 103 (9d10+54)</p>'
        dom = parse_html(html)
        dice = [Models::Die.new(count: 9, sides: 10, bonus: 54)]
        parser = Parsers::Hp.new(dom)

        result = parser.dice

        expect(result).to eq(dice)
      end
    end

    describe '#parent_element' do
      it 'returns element containing the hp text' do
        html = '<p class="stat-block-1"><b>hp</b> 103 (9d10+54)</p>'
        dom = parse_html(html)
        parent = dom.at('p')
        parser = Parsers::Hp.new(dom)

        result = parser.parent_element

        expect(result).to eq(parent)
      end
    end
  end
end
