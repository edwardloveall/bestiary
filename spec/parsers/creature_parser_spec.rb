module Bestiary
  RSpec.describe Parsers::Creature do
    describe '#perform' do
      context 'with a single creature file' do
        it 'returns a DocumentFragment in an array' do
          html = fixture_load('troll.html')
          dom = parse_html(html)

          result = Parsers::Creature.perform(dom)

          expect(result).to be_a(Array)

          creature = result.first

          expect(creature).to be_a(Nokogiri::HTML::DocumentFragment)
          expect(creature.children.count).to be > 10
        end
      end
    end
  end
end
