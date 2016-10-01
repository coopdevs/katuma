require 'rails_helper'

module Products
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

      describe 'price' do
        context 'passing a string as value' do
          let(:product) { FactoryGirl.build(:product, price: string) }

          context 'when the string can be casted to a number' do
            let(:string) { '10.23' }

            it 'does accept the string as a valid value' do
              expect { product.save! }.to_not raise_error
            end
          end

          context 'when the string cannot be casted to a number' do
            let(:string) { 'Hola' }

            it 'does not accept the string as a valid value' do
              expect { product.save! }.to raise_error(
                ActiveRecord::RecordInvalid,
                'Validation failed: Price is not a number'
              )
            end
          end
        end
      end

      describe 'unit' do
        context 'passing a string as value' do
          let(:product) { FactoryGirl.build(:product, unit: string) }

          context 'when the string can be casted to a number' do
            let(:string) { '0' }

            it 'does accept the string as a valid value' do
              expect { product.save! }.to_not raise_error
            end
          end

          context 'when the string cannot be casted to a number' do
            let(:string) { 'Hola' }

            it 'does not accept the string as a valid value' do
              expect { product.save! }.to raise_error(
                ActiveRecord::RecordInvalid,
                'Validation failed: Unit is not a number'
              )
            end
          end
        end
      end
    end

    describe 'Associations' do
      it { is_expected.to belong_to(:producer) }
    end
  end
end
