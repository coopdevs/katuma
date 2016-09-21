require 'rails_helper'

module Suppliers
  describe ProviderSerializer do
    let(:producer) do
      producer = FactoryGirl.create(:producer)
      ::Suppliers::Producer.find(producer.id)
    end
    let(:attributes) do
      {
        id: producer.id,
        name: producer.name,
        email: producer.email,
        address: producer.address,
        created_at: producer.created_at,
        updated_at: producer.updated_at
      }
    end

    subject { described_class.new(producer).to_hash }

    it { is_expected.to include(attributes) }
  end
end
