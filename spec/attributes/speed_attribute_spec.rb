module Bestiary
  RSpec.describe Attributes::Speed do
    describe '#==' do
      it 'returns true if attributes are equal' do
        speed_a = Attributes::Speed.new(title: 'fly',
                                        feet: 30,
                                        armored: false,
                                        maneuverability: :perfect)
        speed_b = Attributes::Speed.new(title: 'fly',
                                        feet: 30,
                                        armored: false,
                                        maneuverability: :perfect)

        expect(speed_a).to eq(speed_b)
      end

      it 'returns false if attributes do not match' do
        speed_a = Attributes::Speed.new(title: 'fly',
                                        feet: 30,
                                        armored: false,
                                        maneuverability: :perfect)
        speed_b = Attributes::Speed.new(title: 'movement',
                                        feet: 30,
                                        armored: false)

        expect(speed_a).not_to eq(speed_b)
      end
    end
  end
end
