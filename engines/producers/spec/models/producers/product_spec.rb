require 'rails_helper'

module Producers
  describe Product do
    describe 'Validations' do
      it 'has a valid factory' do
        expect(FactoryGirl.build(:product)).to be_valid
      end

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:price) }
      it { is_expected.to validate_presence_of(:unit) }
      it { is_expected.to validate_presence_of(:producer) }

      it { is_expected.to validate_inclusion_of(:unit).in_array(Product::UNITS.values) }
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:producer) }
    end
  end
end
