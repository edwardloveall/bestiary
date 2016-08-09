module Bestiary
  RSpec.describe Attributes::Type do
    describe '#==' do
      it 'returns true when the Types are equal' do
        type_a = Attributes::Type.new(title: 'Foo', subtypes: %w('bar', 'baz'))
        type_b = Attributes::Type.new(title: 'Foo', subtypes: %w('bar', 'baz'))

        expect(type_a).to eq(type_b)
      end

      it 'returns false when the title is not equal' do
        type_a = Attributes::Type.new(title: 'Bat', subtypes: %w('bar', 'baz'))
        type_b = Attributes::Type.new(title: 'Foo', subtypes: %w('bar', 'baz'))

        expect(type_a).not_to eq(type_b)
      end

      it 'returns false when a subtype is missing' do
        type_a = Attributes::Type.new(title: 'Foo', subtypes: ['baz'])
        type_b = Attributes::Type.new(title: 'Foo', subtypes: %w('bar', 'baz'))

        expect(type_a).not_to eq(type_b)
      end

      it 'returns false when a subtypes do not match' do
        type_a = Attributes::Type.new(title: 'Foo', subtypes: %w('dog', 'cat'))
        type_b = Attributes::Type.new(title: 'Foo', subtypes: %w('bar', 'baz'))

        expect(type_a).not_to eq(type_b)
      end
    end
  end
end
