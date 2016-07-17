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
      end
    end
  end
end
