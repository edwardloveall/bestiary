module Bestiary
  RSpec.describe Parsers::Name do
    describe '.perform' do
      context 'with a normal name' do
        context 'in standard first last name order' do
          it 'returns the creature name' do
            name = 'Basilisk'
            html = %(<h1 id="#{name.downcase}">#{name}</h1>)
            dom = parse_html(html)

            result = Parsers::Name.perform(dom)

            expect(result).to eq(name)
          end
        end

        context 'in last-name-first order' do
          it 'returns the creature name' do
            html = %(<h1 id="demon-balor">Demon, Balor</h1>)
            dom = parse_html(html)

            result = Parsers::Name.perform(dom)

            expect(result).to eq('Balor Demon')
          end
        end
      end

      context 'with no heading' do
        context 'in standard first last name order' do
          it 'returns the creature name' do
            name = 'Violet Fungus'
            html = %(<p class="stat-block-title"><b>#{name} <span
                     class="stat-block-cr">CR 3</span></b></p>)
            dom = parse_html(html)

            result = Parsers::Name.perform(dom)

            expect(result).to eq(name)
          end
        end
      end
    end
  end
end
