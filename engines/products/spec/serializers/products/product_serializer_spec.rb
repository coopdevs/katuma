require 'rails_helper'

module Products
  describe ProductSerializer do
    let(:product) { FactoryGirl.create(:product) }
    let(:attributes) do
      {
        id: product.id,
        name: product.name,
        price: product.price,
        unit: product.unit,
        producer_id: product.producer_id,
        created_at: product.created_at,
        updated_at: product.updated_at
      }
    end

    subject { described_class.new(product).to_hash }

    it { is_expected.to include(attributes) }
  end
end
