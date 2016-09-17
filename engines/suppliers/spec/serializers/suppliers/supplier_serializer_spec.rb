require 'rails_helper'

module Suppliers
  describe SupplierSerializer do
    let(:group) do
      group = FactoryGirl.create(:group)
      ::Suppliers::Group.find(group.id)
    end
    let(:producer) do
      producer = FactoryGirl.create(:producer)
      ::Suppliers::Producer.find(producer.id)
    end
    let(:supplier) { FactoryGirl.build(:supplier, group: group, producer: producer) }
    let(:attributes) do
      {
        id: supplier.id,
        group_id: supplier.group_id,
        producer_id: supplier.producer_id,
        created_at: supplier.created_at,
        updated_at: supplier.updated_at
      }
    end

    subject { described_class.new(supplier).to_hash }

    it { is_expected.to include(attributes) }
  end
end
