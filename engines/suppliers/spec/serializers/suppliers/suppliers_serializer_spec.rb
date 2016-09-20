require 'rails_helper'

module Suppliers
  describe SuppliersSerializer do
    let(:first_supplier) do
      instance_double(
        Supplier,
        id: 666,
        group_id: 12,
        producer_id: 24,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:second_supplier) do
      instance_double(
        Supplier,
        id: 667,
        group_id: 13,
        producer_id: 25,
        created_at: Time.now.utc,
        updated_at: Time.now.utc
      )
    end
    let(:first_supplier_attributes) do
      {
        id: first_supplier.id,
        group_id: first_supplier.group_id,
        producer_id: first_supplier.producer_id,
        created_at: first_supplier.created_at,
        updated_at: first_supplier.updated_at
      }
    end
    let(:second_supplier_attributes) do
      {
        id: second_supplier.id,
        group_id: second_supplier.group_id,
        producer_id: second_supplier.producer_id,
        created_at: second_supplier.created_at,
        updated_at: second_supplier.updated_at
      }
    end

    subject { described_class.new([first_supplier, second_supplier]).to_hash }

    it { is_expected.to include(first_supplier_attributes, second_supplier_attributes) }
  end
end
