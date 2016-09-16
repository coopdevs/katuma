require 'rails_helper'

module Producers
  describe ProducersSerializer do
    let(:first_producer) { FactoryGirl.build(:producer) }
    let(:second_producer) { FactoryGirl.build(:producer) }
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
