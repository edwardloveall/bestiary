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

      context 'with a multiple creature file' do
        it 'returns DocumentFragments in an array' do
          html = fixture_load('demon.html')
          dom = parse_html(html)

          result = Parsers::Creature.perform(dom)

          expect(result).to be_a(Array)
          expect(result.count).to eq(12)

          result.each do |creature|
            expect(creature).to be_a(Nokogiri::HTML::DocumentFragment)
          end
        end
      end

      context 'with a multiple creature file that has other information' do
        it 'returns DocumentFragments in an array' do
          html = fixture_load('drow.html')
          dom = parse_html(html)

          result = Parsers::Creature.perform(dom)

          expect(result).to be_a(Array)
          expect(result.count).to eq(9)

          result.each do |creature|
            expect(creature).to be_a(Nokogiri::HTML::DocumentFragment)
          end
        end

        context 'when headers are not formted correctly' do
          it 'returns DocumentFragments in an array' do
            html = fixture_load('qlippoth.html')
            dom = parse_html(html)

            result = Parsers::Creature.perform(dom)

            expect(result).to be_a(Array)
            expect(result.count).to eq(7)

            result.each do |creature|
              expect(creature).to be_a(Nokogiri::HTML::DocumentFragment)
            end
          end
        end

        context 'when the challenge rating is a fraction' do
          it 'returns DocumentFragments in an array' do
            html = fixture_load('gremlin.html')
            dom = parse_html(html)

            result = Parsers::Creature.perform(dom)

            expect(result).to be_a(Array)
            expect(result.count).to eq(3)

            result.each do |creature|
              expect(creature).to be_a(Nokogiri::HTML::DocumentFragment)
            end
          end
        end
      end
    end
  end
end
