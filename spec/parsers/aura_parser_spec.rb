module Bestiary
  RSpec.describe Parsers::Aura do
    describe '#parent_element' do
      it 'finds a bold element with the text "Aura"' do
        dom = parse_html('<b>Aura </b>')
        aura = Parsers::Aura.new(dom)

        parent = aura.parent_element

        expect(parent).not_to be_nil
      end

      it 'bold elements with non-"Aura" text' do
        dom = parse_html('<b>Senses</b>')
        aura = Parsers::Aura.new(dom)

        parent = aura.parent_element

        expect(parent).to be_nil
      end

      it 'returns the bold elements parent element' do
        dom = parse_html('<p class="test"><b>Aura </b> foo bar baz</p>')
        test_ele = dom.at('.test')
        aura = Parsers::Aura.new(dom)

        parent = aura.parent_element

        expect(parent).to eq(test_ele)
      end
    end

    describe '#aura_texts' do
      it 'returns a single aura text' do
        text = 'elusive (30 ft.) '
        html = aura_html(text)
        dom = parse_html(html)
        aura = Parsers::Aura.new(nil)

        aura_texts = aura.aura_texts(dom)

        expect(aura_texts).to eq(['elusive (30 ft.)'])
      end

      context 'with multiple auras' do
        context 'the first without attribtes' do
          it 'returns each aura text' do
            text = 'flaming body, <i>'
            text += '<a href="../spells/unholyAura.html#unholy-aura">'
            text += 'unholy aura</a></i> (DC 26)'
            html = aura_html(text)
            dom = parse_html(html)
            aura = Parsers::Aura.new(nil)
            result = ['flaming body', 'unholy aura (DC 26)']

            aura_texts = aura.aura_texts(dom)

            expect(aura_texts).to eq(result)
          end
        end

        context 'the first with attribtes' do
          it 'returns each aura text' do
            html = aura_html('starvation (60 ft., DC 25), flaming body')
            dom = parse_html(html)
            aura = Parsers::Aura.new(nil)
            result = ['starvation (60 ft., DC 25)', 'flaming body']

            aura_texts = aura.aura_texts(dom)

            expect(aura_texts).to eq(result)
          end
        end

        context 'with a bunch of auras with attributes' do
          it 'returns each aura text' do
            text = 'courage (10 ft.), faith (10 ft.), justice (10 ft.),'
            text += 'resolve (10 ft.), righteousness (10 ft.)'
            html = aura_html(text)
            dom = parse_html(html)
            aura = Parsers::Aura.new(nil)
            result = [
              'courage (10 ft.)',
              'faith (10 ft.)',
              'justice (10 ft.)',
              'resolve (10 ft.)',
              'righteousness (10 ft.)'
            ]

            aura_texts = aura.aura_texts(dom)

            expect(aura_texts).to eq(result)
          end
        end
      end
    end

    describe '#feet_parser' do
      it 'returns a hash with a foot key' do
        text = 'amazing thing (10 ft., DC 15, 3 rounds)'
        aura = Parsers::Aura.new(nil)
        hash = { feet: 10 }

        result = aura.feet_parser(text)

        expect(result).to eq(hash)
      end
    end

    describe '#dc_parser' do
      it 'returns a hash with a dc key' do
        text = 'amazing thing (10 ft., DC 15, 3 rounds)'
        aura = Parsers::Aura.new(nil)
        hash = { dc: 15 }

        result = aura.dc_parser(text)

        expect(result).to eq(hash)
      end
    end

    describe '#feet_parser' do
      it 'returns a hash with a rounds key' do
        text = 'amazing thing (10 ft., DC 15, 3 rounds)'
        aura = Parsers::Aura.new(nil)
        hash = { rounds: 3 }

        result = aura.rounds_parser(text)

        expect(result).to eq(hash)
      end
    end

    describe '#minutes_parser' do
      it 'returns a hash with a rounds key' do
        text = 'amazing thing (10 ft., DC 15, 3 minutes)'
        aura = Parsers::Aura.new(nil)
        hash = { minutes: 3 }

        result = aura.minutes_parser(text)

        expect(result).to eq(hash)
      end
    end

    describe '#aura_attributes' do
      it 'returns a hash of attributes' do
        text = 'amazing thing (10 ft., DC 15, 3 minutes, 6 rounds)'
        expected = {
          title: 'amazing thing',
          feet: 10,
          dc: 15,
          rounds: 6,
          minutes: 3
        }
        aura = Parsers::Aura.new(nil)

        hash = aura.aura_attributes(text)

        expect(hash).to eq(expected)
      end
    end

    context '#perform' do
      it 'parses the dom and returns an aura' do
        text = 'starvation (60 ft., DC 25), flaming body'
        html = aura_html(text)
        dom = parse_html(html)
        starvation = Attributes::Aura.new(title: 'starvation', dc: 25, feet: 60)
        flame_body = Attributes::Aura.new(title: 'flaming body')
        expected = [starvation, flame_body]

        auras = Parsers::Aura.perform(dom)

        expect(auras).to eq(expected)
      end
    end

    def aura_html(aura_text)
      "<p class=\"stat-block-1\"><b>Aura</b> #{aura_text}</p>"
    end
  end
end
