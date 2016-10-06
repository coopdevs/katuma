require 'rails_helper'

module Suppliers
  describe ProducersSerializer do
    let(:first_producer) do
      instance_double(
        Producer,
        id: 666,
        name: 'Producer #1',
        email: 'producer+1@katuma.org',
        address: 'c/ del Primer Productor',
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:second_producer) do
      instance_double(
        Producer,
        id: 667,
        name: 'Producer #2',
        email: 'producer+2@katuma.org',
        address: 'c/ del Segon Productor',
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:first_producer_attributes) do
      {
        id: first_producer.id,
        name: first_producer.name,
        email: first_producer.email,
        address: first_producer.address,
        created_at: first_producer.created_at,
        updated_at: first_producer.updated_at
      }
    end
    let(:second_producer_attributes) do
      {
        id: second_producer.id,
        name: second_producer.name,
        email: second_producer.email,
        address: second_producer.address,
        created_at: second_producer.created_at,
        updated_at: second_producer.updated_at
      }
    end

    subject { described_class.new([first_producer, second_producer]).to_hash }

    it { is_expected.to include(first_producer_attributes, second_producer_attributes) }
  end
end
