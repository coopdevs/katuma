require 'rails_helper'

module Producers
  describe ProductsSerializer do
    let(:first_product) { FactoryGirl.create(:product) }
    let(:second_product) { FactoryGirl.create(:product) }
    let(:first_product_attributes) do
      {
        id: first_product.id,
        name: first_product.name,
        price: first_product.price,
        unit: first_product.unit,
        producer_id: first_product.producer_id,
        created_at: first_product.created_at,
        updated_at: first_product.updated_at
      }
    end
    let(:second_product_attributes) do
      {
        id: second_product.id,
        name: second_product.name,
        price: second_product.price,
        unit: second_product.unit,
        producer_id: second_product.producer_id,
        created_at: second_product.created_at,
        updated_at: second_product.updated_at
      }
    end

    subject { described_class.new([first_product, second_product]).to_hash }

    it { is_expected.to include(first_product_attributes, second_product_attributes) }
  end
end
